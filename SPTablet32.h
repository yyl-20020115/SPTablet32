#pragma once
const unsigned short COM_PORT_1 = 0x3f8;
const unsigned short COM_PORT_2 = 0x2f8;

bool setup_tablet(unsigned short port, bool as_emulation = false, bool as_mouse = true);
