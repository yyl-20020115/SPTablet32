#include "pch.h"
#include "SPTablet32API.h"

static void delay_ms(DWORD count);
static void do_handshake(HANDLE hComm);
static bool write_data(HANDLE hComm, unsigned char data);
static bool read_data(HANDLE hComm, unsigned char* pdata);
static bool set_baud_rate(HANDLE hComm, unsigned char byte_size, unsigned char use_parity, unsigned char parity, unsigned short baud_rate);

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
/*
*
Bit1 Bit0 Length
0    0    5
0    1    6
1    0    7
1    1    8

Bit2����ֹλ����Ϊ0��ʾʹ��1����ֹλ����Ϊ1ʱ������������ַ�����Ϊ5ʱ��ʾ1.5����ֹλ�����ַ����Ȳ���5ʱ���ʾ2����ֹλ��
Bit3����żУ��λ��������Ϊ0ʱ��ʾ����żУ��λ����Ϊ1ʱ��ʾʹ����żУ��λ��

Bit4����żУ�鷽ʽѡ����Ϊ0ʱѡ����У�飻��Ϊ1ʱѡ��żУ�顣
Bit5��ָ����żУ��λ�ķ�ʽ����Ϊ0ʱ��ʾ�����ƣ���Ϊ1ʱ����ѡ����У��ʱ����żУ��λΪ1��ѡ��żУ��ʱ����żУ��λΪ0��
Bit6����ֹ����λ����Ϊ0ʱ��ʾ�����������Ϊ1ʱ��ǿ�����0��
Bit7������������λ����Ϊ0ʱ��ʾ��ȡ��Ϣ�Ĵ�������Ϊ1ʱ��ʾ��ȡ�����ʷ�Ƶ����

2, 1200:
0000 0010=7Bits, 1200bps�� 1stop, none parity, no force
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
void do_handshake(HANDLE hComm)
{
	//7bits
	set_baud_rate(hComm, 7, 0, 0, 1200); //0010��1200
	write_data(hComm, 0);
	delay_ms(2);
	write_data(hComm, 0x58);
	delay_ms(4);
	set_baud_rate(hComm, 8,1,0, 9600); //1011,9600
};
