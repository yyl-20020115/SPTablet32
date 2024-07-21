#include "pch.h"
#include <windows.h>
#include "SPTablet32.h"

static void delay_ms(int count);
static void write_mcr_delay(unsigned short port, int count);
static void set_interrupt(unsigned short port);
static void do_handshake(unsigned short port);
static void set_baud_rate_factor(unsigned short port, unsigned char controls, unsigned short baud_factor);
static void write_data(unsigned short port, unsigned char data);
static unsigned char read_mcr(unsigned short port);
static unsigned char read_lsr(unsigned short port);
static unsigned char read_data_wrapper(unsigned short port,unsigned char* ret);
static unsigned char read_data(unsigned short port);
static unsigned short get_baud_factor(unsigned int baud_rate);
static unsigned short get_baud_rate(unsigned short baud_factor);

void __outbyte_impl(unsigned short port, unsigned char data) {
	__outbyte(port, data);
}
unsigned char __inbyte_impl(unsigned short port) {
	return __inbyte(port);
}

bool setup_tablet(unsigned short port, bool as_emulation, bool as_mouse)
{
	unsigned char data = 0;
	unsigned char ret = 0;

	if (0 == (read_mcr(port) & 0b11))
	{
		write_mcr_delay(port, 28);
	}
	do_handshake(port);
	set_interrupt(port);
	write_data(port, 0);
	delay_ms(4);

	write_data(port, 0x3F);
	data = read_data_wrapper(port,&ret);
	if (data != 0)
	{
		switch (data) {
		case 3:
			write_data(port, as_mouse ? 0 : 0x4B);
			return true;
		case 4:
			if (!as_mouse)
			{
				write_data(port, 0x4B);
			}
			else
			{
				if (as_emulation)
				{
					write_data(port, 0x4F);
					write_data(port, 0x62);
				}
				else
				{
					write_data(port, 0x58);
					write_data(port, 0x6F);
				}
			}
			return true;
		case 6:
			write_data(port, as_mouse ? (as_emulation ? 0x5A : 0x6F) : 0x4B);
			return true;
		default:
			return data == 2 || data == 8;
		}
	}

	return true;
}

void write_mcr_delay(unsigned short port, int count)
{
	//0x3F8+4=0x3FC
	//0x0B = 1011
	//BIT0=1 ;DTR
	//BIT1=1 ;DTS
	//BIT2=0 ;用于控制芯片上的输出，新型芯片现已不用。
	//BIT3=1 ;用于控制芯片上的输出，新型芯片现已不用。
	//BIT4=0 ;不进行自我诊断
	__outbyte_impl(port + 4, 0b1011);
	delay_ms(count);
}
unsigned char read_mcr(unsigned short port)
{
	//0x3F8+4=0x3FC
	//调制解调器控制寄存器 (MCR)
	/*
		Bit0：设为1时，DTR脚位为LOW；设为0时，DTR脚位为HIGH。
		Bit1：设为1时，DTS脚位为LOW；设为0时，RTS脚位为HIGH
		Bit2，Bit3：用于控制芯片上的输出，新型芯片现已不用。
		Bit4：：设为1时，芯片内部作自我诊断。
	*/
	return __inbyte_impl(port + 4);
}

void delay_ms(int count)
{
	unsigned int result; // eax

	result = count + GetTickCount();
	while (result > GetTickCount());
}

void write_data(unsigned short port, unsigned char data)
{
	unsigned char status; // al

	//3F8+4=3FC:读取 调制解调器控制寄存器
	status = __inbyte_impl(port + 4);
	do
	{
		//读取 传输线状态寄存器
		status = read_lsr(port);
	} while (0 == (status & 0x20)); //0010 0000
	//3F8:传送信息/接收信息寄存器
	__outbyte_impl(port, data);
}
unsigned char read_lsr(unsigned short port)
{
	//0x3F8+5=0x3FD
	//传输线状态寄存器
	return __inbyte_impl(port + 5);
}
unsigned char read_data_wrapper(unsigned short port,unsigned char* pret)
{
	if(pret!=0) *pret = 0;
	unsigned char result = read_data(port);
	if (result == 0x53)
		result = 0x06;
	switch (result) {
	case 0x53:
		result = 0x06;
		if (pret != 0) *pret = 0;
		break;
	case 0x2:
	case 0x3:
	case 0x4:
	case 0x6:
		if (pret != 0) *pret = 0;
		break;
	case 0x8:
		if (pret != 0) *pret = 1;
		break;
	default:
		break;
	}
	return result;
}

unsigned char read_data(unsigned short port)
{
	DWORD v0; // ah
	signed int v1; // ecx
	unsigned char is_read_ready; // al
	bool v3; // zf

	v0 = GetTickCount();
	v1 = 5;
	while (1)
	{
		//读取 传输线状态寄存器
		is_read_ready = read_lsr(port);
		if (is_read_ready & 1)
			break;
		v3 = (v0 == GetTickCount());
		if (v0 != GetTickCount())
		{
			v0 = GetTickCount();
			--v1;
			if (!v3 || !v1)
				return is_read_ready;
		}
	}
	//
	return __inbyte_impl(port);
}

void set_interrupt(unsigned short port)
{
	unsigned char in_data; // al
	unsigned char out_data; // al

	set_baud_rate_factor(port, 11, 12); //1200bps
	in_data = __inbyte_impl(0x21);
	//8259A PIC
	//0x20: Control Port
	//0x21: Data Port
	if (port == 0x2F8) //COM2
		out_data = in_data & 0xF7; //0b11110111
	else
		out_data = in_data & 0xEF; //0b11101111
	//设置中断
	__outbyte_impl(0x21, out_data);
	//3F8+4=3FC:调制解调器控制寄存器, 0b1011
	__outbyte_impl(port + 4, 11);
	//3F8+1=3F9:中断启动寄存器
	//Bit0：接收的信息有效中断启动。
	//Bit1：传送器保持寄存器已空中断启动
	//Bit2：接收器连接状态中断启动
	//Bit3：调制解调器状态中断启动
	// Bit4－Bit7：永远为0
	// outportb(0x3f9, 0x01); //启动中断，接收数据有效
	__outbyte_impl(port + 1, 1);
}

//可以有两种波特率选择
//2,96  : 0010,96->1200(bps) DTS
//11,12:  1011,12->9600(bps) DTS+DTR+CONTROL
//Bit0：设为1时，DTR脚位为LOW；设为0时，DTR脚位为HIGH。
//Bit1：设为1时，DTS脚位为LOW；设为0时，RTS脚位为HIGH
//Bit2，Bit3：用于控制芯片上的输出，新型芯片现已不用。

void set_baud_rate_factor(unsigned short port, unsigned char controls, unsigned short baud_factor)
{
	//3F8+3=3FB:传输线控制寄存器LCR
	//对LCR的最高位置‘1',是说明以下为输入波特率因子
	__outbyte_impl(port + 3, 0x80);
	//设置波特率
	__outbyte_impl(port + 0, LOBYTE(baud_factor));
	__outbyte_impl(port + 1, HIBYTE(baud_factor));
	//3F8+3=3FB:传输线控制寄存器LCR
	__outbyte_impl(port + 3, controls);
}

void do_handshake(unsigned short port)
{
	set_baud_rate_factor(port, 2, 96); //0010，1200
	write_data(port, 0);
	delay_ms(2);
	write_data(port, 0x58);
	delay_ms(4);
	set_baud_rate_factor(port, 11, 12); //1011,9600
}
static unsigned short get_baud_factor(unsigned int baud_rate)
{
	return 1843200 / (16 * baud_rate);
}
static unsigned short get_baud_rate(unsigned short baud_factor)
{
	return 1843200 / baud_factor / 16;
}
