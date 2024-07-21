#include "pch.h"
#include "SPTablet32API.h"

static void delay_ms(DWORD count);
static void do_handshake(HANDLE hComm);
static bool write_data(HANDLE hComm, unsigned char data);
static bool read_data(HANDLE hComm, unsigned char* pdata);
static bool set_baud_rate(HANDLE hComm, unsigned char controls, unsigned short baud_rate);

bool setup_tablet(LPCTSTR com_port, bool as_emulation, bool as_mouse)
{
	bool done = false;
	unsigned char data = 0;
	HANDLE hComm = CreateFile(com_port,
		OPEN_EXISTING,
		GENERIC_READ | GENERIC_WRITE,
		0,
		0, //FILE_SHARE_NONE 
		0,
		NULL
	);
	if (hComm != INVALID_HANDLE_VALUE) {
		do_handshake(hComm);
		write_data(hComm, 0);
		delay_ms(4);
		write_data(hComm, 0x3F);
		if (read_data(hComm, &data))
		{
			switch (data) {
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
				done = data == 2 || data == 8;
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
bool write_data(HANDLE hComm, unsigned char data)
{
	DWORD n = 0;
	return WriteFile(hComm, &data, sizeof(data), &n, NULL) && n == sizeof(data);
}
bool read_data(HANDLE hComm, unsigned char* pdata)
{
	DWORD n = 0;
	return ReadFile(hComm, pdata, sizeof(*pdata), &n, NULL) && n == sizeof(*pdata);
}
bool set_baud_rate(HANDLE hComm, unsigned char controls, unsigned short baud_rate)
{
	//BIT0=1 ;DTR
	//BIT1=1 ;DTS
	bool DTR = (controls & 0x1) != 0;
	bool DTS = (controls & 0x2) != 0;
	if (DTR)
	{
		EscapeCommFunction(hComm, SETDTR);
	}
	else {
		EscapeCommFunction(hComm, CLRDTR);
	}
	if (DTS)
	{
		EscapeCommFunction(hComm, SETRTS);
	}
	else
	{
		EscapeCommFunction(hComm, CLRRTS);
	}

	DCB dcb = { 0 };
	dcb.DCBlength = sizeof(dcb);
	if (!GetCommState(hComm, &dcb)) return false;
	dcb.BaudRate = baud_rate;
	dcb.fDtrControl = DTR_CONTROL_ENABLE;
	dcb.fRtsControl = RTS_CONTROL_ENABLE;
	return SetCommState(hComm, &dcb) != 0;
}
void do_handshake(HANDLE hComm)
{
	set_baud_rate(hComm, 2, 1200); //0010£¬1200
	write_data(hComm, 0);
	delay_ms(2);
	write_data(hComm, 0x58);
	delay_ms(4);
	set_baud_rate(hComm, 11, 9600); //1011,9600
};
