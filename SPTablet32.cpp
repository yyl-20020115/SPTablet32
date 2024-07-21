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
	//BIT2=0 ;���ڿ���оƬ�ϵ����������оƬ���Ѳ��á�
	//BIT3=1 ;���ڿ���оƬ�ϵ����������оƬ���Ѳ��á�
	//BIT4=0 ;�������������
	__outbyte_impl(port + 4, 0b1011);
	delay_ms(count);
}
unsigned char read_mcr(unsigned short port)
{
	//0x3F8+4=0x3FC
	//���ƽ�������ƼĴ��� (MCR)
	/*
		Bit0����Ϊ1ʱ��DTR��λΪLOW����Ϊ0ʱ��DTR��λΪHIGH��
		Bit1����Ϊ1ʱ��DTS��λΪLOW����Ϊ0ʱ��RTS��λΪHIGH
		Bit2��Bit3�����ڿ���оƬ�ϵ����������оƬ���Ѳ��á�
		Bit4������Ϊ1ʱ��оƬ�ڲ���������ϡ�
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

	//3F8+4=3FC:��ȡ ���ƽ�������ƼĴ���
	status = __inbyte_impl(port + 4);
	do
	{
		//��ȡ ������״̬�Ĵ���
		status = read_lsr(port);
	} while (0 == (status & 0x20)); //0010 0000
	//3F8:������Ϣ/������Ϣ�Ĵ���
	__outbyte_impl(port, data);
}
unsigned char read_lsr(unsigned short port)
{
	//0x3F8+5=0x3FD
	//������״̬�Ĵ���
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
		//��ȡ ������״̬�Ĵ���
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
	//�����ж�
	__outbyte_impl(0x21, out_data);
	//3F8+4=3FC:���ƽ�������ƼĴ���, 0b1011
	__outbyte_impl(port + 4, 11);
	//3F8+1=3F9:�ж������Ĵ���
	//Bit0�����յ���Ϣ��Ч�ж�������
	//Bit1�����������ּĴ����ѿ��ж�����
	//Bit2������������״̬�ж�����
	//Bit3�����ƽ����״̬�ж�����
	// Bit4��Bit7����ԶΪ0
	// outportb(0x3f9, 0x01); //�����жϣ�����������Ч
	__outbyte_impl(port + 1, 1);
}

//���������ֲ�����ѡ��
//2,96  : 0010,96->1200(bps) DTS
//11,12:  1011,12->9600(bps) DTS+DTR+CONTROL
//Bit0����Ϊ1ʱ��DTR��λΪLOW����Ϊ0ʱ��DTR��λΪHIGH��
//Bit1����Ϊ1ʱ��DTS��λΪLOW����Ϊ0ʱ��RTS��λΪHIGH
//Bit2��Bit3�����ڿ���оƬ�ϵ����������оƬ���Ѳ��á�

void set_baud_rate_factor(unsigned short port, unsigned char controls, unsigned short baud_factor)
{
	//3F8+3=3FB:�����߿��ƼĴ���LCR
	//��LCR�����λ�á�1',��˵������Ϊ���벨��������
	__outbyte_impl(port + 3, 0x80);
	//���ò�����
	__outbyte_impl(port + 0, LOBYTE(baud_factor));
	__outbyte_impl(port + 1, HIBYTE(baud_factor));
	//3F8+3=3FB:�����߿��ƼĴ���LCR
	__outbyte_impl(port + 3, controls);
}

void do_handshake(unsigned short port)
{
	set_baud_rate_factor(port, 2, 96); //0010��1200
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
