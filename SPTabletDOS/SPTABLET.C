//COMPILE WITH TURBO C++ 3.0 UNDER DOS / WIN9X DOS MODE
#include <stdio.h>
#include <string.h>

#ifdef _WIN32
#include <Windows.h>
#define stricmp _stricmp
#else
#include <dos.h>
#endif

#ifndef MICROSOFT_MOUSE
#define MICROSOFT_MOUSE 0
#endif

#ifndef MMSYSTEM_MOUSE
#define MMSYSTEM_MOUSE 1
#endif

#ifndef TRUE
#define TRUE 1
#endif

#ifndef FALSE
#define FALSE 1
#endif

#ifndef TICK_COUNT_PTR
#define TICK_COUNT_PTR 0x46C
#endif

#ifndef COM_PORT1
#define COM_PORT1 0x3f8
#endif

#ifndef COM_PORT2
#define COM_PORT2 0x2f8
#endif
unsigned int setup_tablet(unsigned char choice, unsigned char as_emulation, unsigned char mouse_type);
unsigned int setup_tablet_at(unsigned short port, unsigned char as_emulation, unsigned char mouse_type);
unsigned char write_mcr(unsigned short port, unsigned char mode);
unsigned char read_mcr(unsigned short port);
unsigned char read_lsr(unsigned short port);
unsigned char read_data_sp(unsigned short port, unsigned char* pch);
unsigned char read_data(unsigned short port, unsigned char* pch);
unsigned char set_interrupt(unsigned short port);
unsigned char do_handshake(unsigned short port);
unsigned char write_data(unsigned short port, unsigned char data);
unsigned char set_baud_rate(unsigned short port, unsigned char mode, unsigned short baud_factor);
unsigned char __inbyte(unsigned short port);
void __outbyte(unsigned short port, unsigned char data);
unsigned short get_tick_count();
unsigned int delay_ms(unsigned int count);

const char aParameterError[] = "Parameter Error!\r\n"
"Use /?, /1, /2, /E or /M\r\n";
const char aThisProgramCan[] = "This program can not run within Windows!\r\nExit Windows, and run this from DOS prompt\r\n";
const char aTabletIsNotRes[] = "Tablet is not Responding!\r\n";
const char aNotSpTablet[] = "Not SP tablet!\r\n";
const char aSetTabletModeOK[] = "Set Tablet Mode OK!\r\n";
const char aResetTabletOk[] = "Reset Tablet OK!\r\n";
const char aTabletConnectT_1[] = "Tablet Connect to COM1\r\n";
const char aTabletConnectT_2[] = "Tablet Connect to COM2\r\n";
const char aSptabletCanUse[] =
"SPTablet      can use following command.\r\n"
"  /?          This message.\r\n"
"  /x          x = 1 or 2 to setup COM1 or COM2.\r\n"
"  /E          Set Emulation On. SP345 will emulate MM9601,\r\n"
"                                SP66 will emulate MM1212. \r\n"
"  /M          Set Emulation Microsoft Mouse On.\r\n"
"              If no /M this will set to MM series tablet.\r\n"
;
#ifdef _WIN32
unsigned short get_tick_count()
{
	return (unsigned short)GetTickCount();
}
#else
unsigned char __inbyte(unsigned short port)
{
	unsigned char data;
	data = inportb(port);
	printf("%02X<-%04X  ", data, port);
	return data;
}

void __outbyte(unsigned short port, unsigned char data)
{
	outportb(port, data);
	printf("%02X->%04X  ", data, port);
}
unsigned short get_tick_count()
{
	return peek(0, TICK_COUNT_PTR);
}
#endif
unsigned int setup_tablet_at(unsigned short port, unsigned char as_emulation, unsigned char mouse_type)
{
	int retries = 0;
	unsigned char ch = 0xff;
	unsigned char cmd = 0;
	const char* message = 0;
	if (!(read_mcr(port) & 3))
	{
		write_mcr(port, 0x0B);
		delay_ms(28);
	}
	do_handshake(port);
	set_interrupt(port);
	write_data(port, 0);
	delay_ms(4);
	for (retries = 0; retries < 256; retries++)
	{
		write_data(port, 0x3F);
		if (read_data_sp(port, &ch))break;
	}

	cmd = 0xff;
	if ((unsigned char)ch == 0xff)
	{
		printf("ERROR:%s", aTabletIsNotRes);
		return FALSE;

	}
	else if (ch == 4)
	{
		if (mouse_type == MICROSOFT_MOUSE)
		{
			cmd = 0x4B;
		}
		else
		{
			if (as_emulation)
			{
				write_data(port, 0x4F);
				cmd = 0x62;
			}
			else
			{
				write_data(port, 0x58);
				cmd = 0x6F;
			}
		}
	}
	else if (ch == 3)
	{
		cmd = mouse_type == MICROSOFT_MOUSE ? 0x4B : 0;
	}
	else
	{
		if (ch != 6)
		{
			if (ch != 2 && ch != 8)
			{

				printf("ERROR:%s", aNotSpTablet);
				return FALSE;
			}
		_final:
			if (mouse_type == MICROSOFT_MOUSE)
			{
				message = aResetTabletOk;
			}
			else
			{
				printf("%s", aSetTabletModeOK);
				if (port == COM_PORT1)
					message = aTabletConnectT_1;
				else
					message = aTabletConnectT_2;
			}
			printf("%s", message);
			return TRUE;
		}
		cmd = mouse_type == MICROSOFT_MOUSE ? 0x4B 
			: (as_emulation ? 0x5A : 0x6F);
	}
	write_data(port, cmd);
	goto _final;
}
unsigned int setup_tablet(unsigned char choice, unsigned char as_emulation, unsigned char mouse_type)
{
	switch (choice)
	{
	case 0:
		if (!setup_tablet_at(COM_PORT1, as_emulation, mouse_type))
		{
			if (!setup_tablet_at(COM_PORT2, as_emulation, mouse_type))
			{
				return FALSE;
			}
			return TRUE;
		}
		else {
			return TRUE;
		}
	case 1:
		return setup_tablet_at(COM_PORT1, as_emulation, mouse_type);
	case 2:
		return setup_tablet_at(COM_PORT2, as_emulation, mouse_type);
	}
	return FALSE;
}
unsigned int delay_ms(unsigned int count)
{
	unsigned int target;
	unsigned int current;

	target = get_tick_count() + count;
	do
		current = get_tick_count();
	while (current < target);
	return current;
}
unsigned char read_mcr(unsigned short port)
{
	return __inbyte(port + 4);
}
unsigned char read_lsr(unsigned short port)
{
	return __inbyte(port + 5);
}
unsigned char read_dr(unsigned short port)
{
	return __inbyte(port);
}
unsigned char write_dr(unsigned short port, unsigned char data)
{
	__outbyte(port, data);
	return data;
}
unsigned char write_mcr(unsigned short port, unsigned char mode)
{
	__outbyte(port + 4, mode); //write mcr
	return mode;
}
unsigned char write_ier(unsigned short port, unsigned char mode)
{
	__outbyte(port + 1, mode); //write ier
	return mode;
}
unsigned char write_lcr(unsigned short port, unsigned char mode)
{
	__outbyte(port + 3, mode); //write lcr
	return mode;
}
unsigned short write_bdr(unsigned short port, unsigned short baud_factor)
{
	__outbyte(port + 1, (unsigned char)((baud_factor >> 8) & 0xff));
	__outbyte(port, (unsigned char)baud_factor & 0xff);
	return baud_factor;
}
unsigned char read_imr()
{
	return __inbyte(0x21);
}
unsigned char write_imr(unsigned char mode)
{
	__outbyte(0x21,mode); //write imr
	return mode;
}
unsigned char write_data(unsigned short port, unsigned char data)
{
	unsigned char status;
	read_mcr(port);
	do {
		status = read_lsr(port);
	} while (0 == (status & 0x20));
	write_dr(port, data);
	return data;
}
unsigned char read_data_sp(unsigned short port, unsigned char* pch)
{
	unsigned char result = read_data(port, pch);
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
		result = 1;
		break;
	default:
		result = 0;
		break;
	}
	return result;
}
unsigned char read_data(unsigned short port, unsigned char* pch)
{
	unsigned char data, status;
	int i;
	unsigned char start, current;
	start = (unsigned char)(get_tick_count() >> 8);
	for (i = 0; i < 5; i++)
	{

		status = read_lsr(port);
		if ((status & 1) != 0) {
			data = read_dr(port);
			if (pch != 0) *pch = data;
			return TRUE;
		}
		current = (unsigned char)(get_tick_count() >> 8);
		//break if waiting for longer than ms
		if (current != start) break;
		current = start;
	}
	return FALSE;
}
unsigned char set_interrupt(unsigned short port)
{
	unsigned char val;
	set_baud_rate(port, 0xB, 0xC); //9600,ODD,8,1
	val = read_imr(); //READ IMR
	if (port == COM_PORT2)
		val &= 0xF7; //IRQ3
	else
		val &= 0xEF; //IRQ4
	write_imr(val);//0:Enable,1:Disable:: here is 0,enable
	write_mcr(port, 0xB);//MCR: Reset Hardware
	write_ier(port, 0x1);//IER: Enable Interrupt
	return val;
}
unsigned char set_baud_rate(unsigned short port, unsigned char mode, unsigned short baud_factor)
{
	write_lcr(port, 0x80);
	write_bdr(port, baud_factor);
	write_lcr(port, mode);
	return mode;
}
unsigned char do_handshake(unsigned short port)
{
	//1200, 7, NONE,1
	set_baud_rate(port, 2, 96);
	write_data(port, 0);
	delay_ms(2);
	write_data(port, 0x58);
	delay_ms(4);
	//9600,8,ODD,1
	return set_baud_rate(port, 0xB, 12);
}

int main(int argc, char* argv[])
{
	int i = 0;
	unsigned char choice = 0, as_emulation = 0, mouse_type = MMSYSTEM_MOUSE;
#ifndef _WIN32
	_AX = 0x160A;
	geninterrupt(0x2f);
	if (_AX == 0x160A)
#endif
	{   //argv[0]: app name
		for (i = 1; i < argc; i++)
		{
			if (0 == stricmp(argv[i], "/?"))
			{
				printf(aSptabletCanUse);
				return 0;
			}
			else if (0 == stricmp(argv[i], "/1"))
			{
				choice = 1;
			}
			else if (0 == stricmp(argv[i], "/2"))
			{
				choice = 2;
			}
			else if (0 == stricmp(argv[i], "/E"))
			{
				as_emulation = 1;
			}
			else if (0 == stricmp(argv[i], "/M"))
			{
				mouse_type = MICROSOFT_MOUSE;
			}
			else {
				printf(aParameterError);
				return 1;
			}
		}
		printf("SPTABLET\r\n");
		return !setup_tablet(choice, as_emulation, mouse_type);
	}
#ifndef _WIN32
	else {
		printf(aThisProgramCan);
		return 1;
	}
#endif
}