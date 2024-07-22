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
	mouse_system_protocol = 0,
	sp_mouse = 1
} mouse_protocol;

/*
9600 ODD 8 1
mouse system mouse protocol:
BYTE 0   1  0  0  0  0  L  M  R     80
BYTE 1   X7 X6 X5 X4 X3 X2 X1 X0    80
BYTE 2   Y7 Y6 Y5 Y4 Y3 Y2 Y1 Y0    00
BYTE 3   X7 X6 X5 X4 X3 X2 X1 X0    E0
BYTE 4   Y7 Y6 Y5 Y4 Y3 Y2 Y1 Y0    80

microsoft mouse protocol:
BYTE 0  1  1  L  R  Y7 Y6 X7 X6
BYTE 1  0  0  X5 X4 X3 X2 X1 X0
BYTE 2  0  0  Y5 Y4 Y3 Y2 Y1 Y0
*/
tablet_status setup_tablet(LPCTSTR com_port, mouse_protocol mouse_type = mouse_system_protocol, bool as_emulation = false);
