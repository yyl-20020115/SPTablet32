#include "pch.h"
#include "SPTablet32API.h"

static void delay_ms(DWORD count);
static bool do_handshake(HANDLE hComm);
static bool write_data(HANDLE hComm, unsigned char data);
static bool read_data(HANDLE hComm, unsigned char* pch);
static bool set_baud_rate(HANDLE hComm, unsigned char byte_size, unsigned char use_parity, unsigned char parity, unsigned short baud_rate);
static DWORD  read_mcr(HANDLE hComm);
static bool write_mcr(HANDLE hComm, bool dtr, bool rts);
static bool set_interrupt(HANDLE hComm);
static bool read_data_sp(HANDLE hComm, unsigned char* pch);

bool setup_tablet(LPCTSTR com_port, bool as_mouse, bool as_emulation)
{
	bool done = false;
	unsigned char ch = 0;
	HANDLE hComm = CreateFile(
		com_port,
		GENERIC_READ | GENERIC_WRITE,
		0, //FILE_SHARE_NONE 
		NULL,
		OPEN_EXISTING,
		FILE_ATTRIBUTE_NORMAL,
		NULL
	);
	if (hComm != INVALID_HANDLE_VALUE) {
		//reset modem
		COMMTIMEOUTS cmo = { 0 };
		
		GetCommTimeouts(hComm, &cmo);
		cmo.ReadIntervalTimeout = 256;
		SetCommTimeouts(hComm, &cmo);

		if ((read_mcr(hComm)&0x3) ==0) {
			write_mcr(hComm, true, true);
			delay_ms(28);
		}

		done &= do_handshake(hComm);
		done &= set_interrupt(hComm);
		done &= write_data(hComm, 0);
		delay_ms(4);
		done = write_data(hComm, 0x3F);
		int retries = 0;
		for (; retries < 256; retries++)
		{
			write_data(hComm, 0x3F);
			if (read_data_sp(hComm, &ch))break;
		}
		{
			switch (ch) {
			case 3:
				write_data(hComm, as_mouse ? 0 : 0x4B);
				done = true;
				break;
			case 4:
				if (!as_mouse)
				{
					write_data(hComm, 0x4B);
				}
				else
				{
					if (as_emulation)
					{
						write_data(hComm, 0x4F);
						write_data(hComm, 0x62);
					}
					else
					{
						write_data(hComm, 0x58);
						write_data(hComm, 0x6F);
					}
				}
				done = true;
				break;
			case 6:
				write_data(hComm, as_mouse ? (as_emulation ? 0x5A : 0x6F) : 0x4B);
				done = true;
				break;
			default:
				done = !(ch != 2 && ch != 8);
				break;
			}
		}
		CloseHandle(hComm);
	}

	return done;
}
void delay_ms(DWORD count) {
	Sleep(count);
}
DWORD read_mcr(HANDLE hComm) {

	DWORD stat = 0;
	
	BOOL done = GetCommModemStatus(hComm, &stat);

	return done ? (((stat & MS_DSR_ON) != 0) << 1) | ((stat & MS_CTS_ON) != 0):~0;
}
bool write_mcr(HANDLE hComm, bool dtr, bool rts) {
	// MCR 用来控制调制解调器的接口信号。
	//	Bit0：设为1时，DTR脚位为LOW；设为0时，DTR脚位为HIGH。
	//	Bit1：设为1时，RTS脚位为LOW；设为0时，RTS脚位为HIGH
	//	Bit2，Bit3：用于控制芯片上的输出，新型芯片现已不用。
	//	Bit4：：设为1时，芯片内部作自我诊断。
	//	其他位永远为0
	// 0000 1011
	//	outportb(0x3fc, 0x0b);  //见上 

	BOOL done = TRUE;
	if (dtr) {
		done &= EscapeCommFunction(hComm, SETDTR);
	}
	else {
		done &= EscapeCommFunction(hComm, CLRDTR);

	}
	if (rts) {
		done &= EscapeCommFunction(hComm, SETRTS);
	}
	else {
		done &= EscapeCommFunction(hComm, CLRRTS);

	}
	return done != 0;
}
bool write_data(HANDLE hComm, unsigned char data)
{
	//read mcr first
	read_mcr(hComm);
	bool done = TransmitCommChar(hComm, data) != 0;
	return done;
}
bool read_data_sp(HANDLE hComm, unsigned char* pch)
{
	bool result = read_data(hComm, pch);
	switch (*pch)
	{
	case 0x53:
		*pch = 0x06;
		break;
	case 2:
	case 3:
	case 4:
	case 6:

		break;
	case 8:
		result = true;
		break;
	default:
		result = false;
		break;
	}
	return result;
}
bool read_data(HANDLE hComm, unsigned char* pch)
{
	DWORD n = 0;
	for (int i = 0; i < 5; i++) {
		if (ReadFile(hComm, pch, sizeof(*pch), &n, NULL) && n == sizeof(*pch)) {
			return true;
		}
		else if (GetLastError() == ERROR_TIMEOUT) {
			return false;
		}
	}
	return false;
}
bool set_interrupt(HANDLE hComm) 
{
	return true;
}
/*
*
Bit1 Bit0 Length
0    0    5
0    1    6
1    0    7
1    1    8

Bit2：终止位。设为0表示使用1个终止位；设为1时有两种情况，字符长度为5时表示1.5个终止位，而字符长度不是5时则表示2个终止位。
Bit3：奇偶校验位启动。设为0时表示无奇偶校验位，设为1时表示使用奇偶校验位。

Bit4：奇偶校验方式选择。设为0时选择奇校验；设为1时选择偶校验。
Bit5：指定奇偶校验位的方式。设为0时表示不限制；设为1时，则选择奇校验时，奇偶校验位为1；选择偶校验时，奇偶校验位为0。
Bit6：终止控制位。设为0时表示正常输出；设为1时则强迫输出0。
Bit7：除法器轩锁位。设为0时表示存取信息寄存器；设为1时表示存取波特率分频器。

2, 1200:	
0000 0010=7Bits, 1200bps， 1stop, none parity, no force
11, 9600:
0000 1011=8Bits, 9600, odd parity

*/
bool set_baud_rate(HANDLE hComm, unsigned char byte_size, unsigned char use_parity, unsigned char parity, unsigned short baud_rate)
{
	DCB dcb = { 0 };
	dcb.DCBlength = sizeof(dcb);
	if (!GetCommState(hComm, &dcb)) return false;
	dcb.ByteSize = byte_size;
	dcb.Parity = use_parity ? parity:0;
	dcb.BaudRate = baud_rate;
	return SetCommState(hComm, &dcb) != 0;
}
bool do_handshake(HANDLE hComm)
{
	//7bits
	bool done = set_baud_rate(hComm, 7, 0, 0, 1200); //0010，1200
	done &= write_data(hComm, 0);
	delay_ms(2);
	done &= write_data(hComm, 0x58);
	delay_ms(4);
	done &= set_baud_rate(hComm, 8,1,0, 9600); //1011,9600
	return done;
};
