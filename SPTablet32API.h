#pragma once
#include <Windows.h>

typedef enum _tablet_status {
	not_sp_tablet = -2,
	not_responding = -1,
	unknown = 0,
	set_tablet_mode_ok = 1,
	reset_tablet_ok = 2
} tablet_status;

typedef enum _mouse_protocol {
	microsoft_mouse_protocol = 0, //CORRECT! WE HAVE TO USE THIS 0 TO INDICATE MOUSE HOVERRING
	mmsystem_mouse_protocol = 1,
} mouse_protocol;

/*
9600 ODD 8 1
mouse system mouse protocol:
BYTE 0   1  0  0  0  0  L  M  R     80
BYTE 1   X7 X6 X5 X4 X3 X2 X1 X0    80 X-HIGH
BYTE 2   Y7 Y6 Y5 Y4 Y3 Y2 Y1 Y0    00 Y-HIGH
BYTE 3   X7 X6 X5 X4 X3 X2 X1 X0    E0 X-LOW
BYTE 4   Y7 Y6 Y5 Y4 Y3 Y2 Y1 Y0    80 Y-LOW

1200, N, 7, 1
microsoft mouse protocol:
BYTE 0   x  1  L  R  Y7 Y6 X7 X6 (11000000 if start frame)
BYTE 1   x  0  X5 X4 X3 X2 X1 X0 (10000000 if start frame)
BYTE 2   x  0  Y5 Y4 Y3 Y2 Y1 Y0 (10000000 if start frame)
*/
tablet_status setup_tablet(LPCTSTR com_port, mouse_protocol mouse_type = microsoft_mouse_protocol, bool as_emulation = false);
