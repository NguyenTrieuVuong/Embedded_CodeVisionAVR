#ifndef ONE_WIRE_H_
#define ONE_WIRE_H_

#include <mega328p.h>

//setup connection
#define onewire_PORT PORTD
#define onewire_DDR DDRD
#define onewire_PIN PIND
#define onewire_DQ PORTD2

//commands
#define DS18B20_CMD_CONVERTTEMP 0x44
#define DS18B20_CMD_RSCRATCHPAD 0xbe
#define DS18B20_CMD_WSCRATCHPAD 0x4e
#define DS18B20_CMD_CPYSCRATCHPAD 0x48
#define DS18B20_CMD_RECEEPROM 0xb8
#define DS18B20_CMD_RPWRSUPPLY 0xb4
#define onewire_CMD_SEARCHROM 0xf0
#define onewire_CMD_READROM 0x33
#define onewire_CMD_MATCHROM 0x55
#define onewire_CMD_SKIPROM 0xcc
#define onewire_CMD_ALARMSEARCH 0xec

//stop any interrupt on read
#define onewire_STOPINTERRUPTONREAD 1

//functions for 1 wire
unsigned char onewire_reset(void);
void onewire_writebit(unsigned char b);
unsigned char onewire_readbit(void);
void onewire_writebyte(unsigned char byte);
unsigned char onewire_readbyte(void);

//Function for DS18b20
float ds18b20_gettemp();

#endif