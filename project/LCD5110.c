/*Import the mega328p.h and alcd_i2c.h libraries, which contain functions
and definitions for the ATmega328P microcontroller and I2C interface with the LCD
*/
#include <mega328p.h>
#include <alcd_i2c.h>
/*
Define two constants SCL_PIN and SDA_PIN of the DS1307 module to specify the
SCL and SDA pins on the microcontroller.
*/
#define SCL_PIN 1
#define SDA_PIN 2

/* delay functions */
#include <delay.h>

/* PCF8574 7-bit I2C slave address set by the
   state of pins A0, A1, A2 of logic 1 */
#define PCF8574_I2C_ADDRESS 0x27

int count = 0;
int count2 = 0;
int hour, min, sec , weekday, date, month, year;
int alarm_hour, alarm_min;

/*Define the i2c_Begin function to initiate I2C communication by setting the
SCL and SDA pins as outputs.*/
void i2c_Begin()
{
	PORTB  |= (1 << SCL_PIN) | (1 << SDA_PIN);
	DDRB |= (1 << SCL_PIN) | (1 << SDA_PIN);
}

/*The setMode function is used to set the SDA pin as input (mode = 0) or
output (mode=1).*/
void setMode(unsigned char mode)
{
	if (mode)
		DDRB |= (1 << SDA_PIN);
	else
		DDRB &= ~(1 << SDA_PIN);
}

/*The i2c_Clock function is used to generate clocks during data transmission
over the I2C interface.*/
static void i2c_Clock(void)
{
	PORTB  |= (1 << SCL_PIN);
	delay_us(4);
	PORTB  &= ~(1 << SCL_PIN);
	delay_us(5);
}

// The i2cStart function initiates the start condition
void i2cStart(void)
{
	PORTB  |= (1 << SDA_PIN);
	delay_us(4);
	PORTB  |= (1 << SCL_PIN);
	delay_us(4);

	PORTB  &= ~(1 << SDA_PIN);
	delay_us(4);
	PORTB  &= ~(1 << SCL_PIN);
	delay_us(4);
}

// i2cStop generates the stop condition
void i2cStop(void)
{
	PORTB  &= ~(1 << SDA_PIN);
	delay_us(4);
	PORTB  |= (1 << SCL_PIN);
	delay_us(5);
	PORTB  |= (1 << SDA_PIN);
	delay_us(5);
}

unsigned int bcd2dec(unsigned int num)
{
	return ((num / 16 * 10) + (num % 16));
}

unsigned int dec2bcd(unsigned int num)
{
	return ((num / 10 * 16) + (num % 10));
}

// i2cWrite is used to write a byte of data over I2C
unsigned int i2cWrite(unsigned int Data)
{
	unsigned int i, x = 0, ack;

	for (i = 0; i < 8; i++)
		{
		x = Data & 0x80;
		PORTB  &= ~(1 << SDA_PIN);
		if (x)
			PORTB  |= (1 << SDA_PIN);
		i2c_Clock();
		Data = Data << 1;
		}

	setMode(0);
	PORTB  |= (1 << SCL_PIN);
	delay_us(2);
	ack = PINB & (1 << SDA_PIN);
	PORTB  &= ~(1 << SCL_PIN);
	delay_us(5);
	setMode(1);

	return ack;
}

void ds1307_Init(void)
{
	i2c_Begin();
	i2cStart();
	i2cWrite(0xD0);
	i2cWrite(0x07);
	i2cWrite(0x00);
	i2cStop();
}

// i2cRead is used to read a byte of data from the I2C bus
unsigned int I2CRead(unsigned int ACK)
{
	unsigned int i, Data = 0;

	setMode(0);
	PORTB  &= ~(1 << SCL_PIN);
	delay_us(4);
	for (i = 0; i < 8; i++)
		{
		PORTB  |= (1 << SCL_PIN);
		Data <<= 1;
		if (PINB & (1 << SDA_PIN))
			Data |= 0x01;
		PORTB  &= ~(1 << SCL_PIN);
		delay_us(5);
		}

	setMode(1);
	if (ACK)
		PORTB  &= ~(1 << SDA_PIN);
	else
		PORTB  |= (1 << SDA_PIN);

	PORTB  |= (1 << SCL_PIN);
	delay_us(4);
	PORTB  &= ~(1 << SCL_PIN);
	delay_us(4);

	return Data;
}

/* The ds1307_Read function is responsible for retrieving the current time
from the DS1307 real-time clock module. It sends the appropriate commands
and reads the data from the module using the I2C communication functions.*/
void ds1307_Read()
{
	i2cStart();
	i2cWrite(0xD0);
	i2cWrite(0x00);
	i2cStart();
	i2cWrite(0xD1);
	sec = bcd2dec(I2CRead(1));
	min = bcd2dec(I2CRead(1));
	hour = bcd2dec(I2CRead(1));
	weekday = bcd2dec(I2CRead(1));
	date = bcd2dec(I2CRead(1));
	month = bcd2dec(I2CRead(1));
	year = bcd2dec(I2CRead(0));
	year += 2000;
	i2cStop();
}

void ds1307_SetTime(unsigned int sec, unsigned int min, unsigned int hour)
{
	i2cStart();
	i2cWrite(0xD0);
	i2cWrite(0x00);
	i2cWrite(dec2bcd(sec));
	i2cStop();

	i2cStart();
	i2cWrite(0xD0);
	i2cWrite(0x01);
	i2cWrite(dec2bcd(min));
	i2cStop();

	i2cStart();
	i2cWrite(0xD0);
	i2cWrite(0x02);
	i2cWrite(dec2bcd(hour));
	i2cStop();
}

void ds1307_SetDate(unsigned int weekday, unsigned int date, unsigned int month, unsigned int year)
{
	i2cStart();
	i2cWrite(0xD0);
	i2cWrite(0x03);
	i2cWrite(dec2bcd(weekday));
	i2cStop();

	i2cStart();
	i2cWrite(0xD0);
	i2cWrite(0x04);
	i2cWrite(dec2bcd(date));
	i2cStop();

	i2cStart();
	i2cWrite(0xD0);
	i2cWrite(0x05);
	i2cWrite(dec2bcd(month));
	i2cStop();

	i2cStart();
	i2cWrite(0xD0);
	i2cWrite(0x06);
	i2cWrite(dec2bcd(year));
	i2cStop();
}

// set backlight timer and is alarm
unsigned int backlightTimer = 0;
int isAlarm = 0;

// mode for button 1
void mode()
{
	PORTB.5 = !PORTB.5;
	count = count + 1;
	if(count > 15 )
		count = 0;
	delay_ms(500);
	backlightTimer = 10;
}

// mode for button 2
void mode2()
{
	PORTB.5 = !PORTB.5;
	count2 = count2 + 1;
	if(count2 > 2 )
		count2 = 0;
	delay_ms(150);
	backlightTimer = 10;
	if ((count == 2 || count == 3) && count2 == 1)
		{
		hour += 1;
		if (hour > 23)
			hour = 0;
		ds1307_SetTime(sec, min, hour);
		}
	if ((count == 4 || count == 5) && count2 == 1)
		{
		min += 1;
		if (min > 59)
			min = 0;
		ds1307_SetTime(sec, min, hour);
		}
	if ((count == 6 || count == 7) && count2 == 1)
        {
        date += 1;
        if (month == 2 && year % 4 ==0){
            if (date > 29){
                date = 1;
            }
        }
        else if (month == 2 && year % 4 !=0){
            if (date > 28){
                date = 1;
            }
        }
        ds1307_SetDate(weekday, date, month, year);
        }
    if ((count == 8 || count == 9) && count2 == 1)
        {
        month += 1;
        if (month > 12) {
            month = 1;
        }
        ds1307_SetDate(weekday, date, month, year);
        }

	if ((count == 10 || count == 11) && count2 == 1)
		{
		alarm_hour += 1;
		if (alarm_hour > 23)
			alarm_hour = 0;
		}
	if ((count == 12 || count == 13) && count2 == 1)
		{
		alarm_min += 1;
		if (alarm_min > 59)
			alarm_min = 0;
		}
	if ((count == 14 || count == 15) && count2 == 1)
		{
		isAlarm += 1;
		if (isAlarm > 1)
			isAlarm = 0;
		}

}

interrupt [EXT_INT0] void external_interrupt_isr(void)
{
	mode();
}

interrupt [EXT_INT1] void external_interrupt1_isr(void)
{
	mode2();
}

void main(void)
{
	DDRD.4 = 1;
	DDRB = DDRB | 0x20;
	PORTB = PORTB & 0x00;
	DDRD &= 0b11110011;   //  D2, D3 is input
	PORTD |= 0b00001100;

	EICRA |= 0b00000010;  // falling edge
	EICRA &= 0b11111110;

	EIMSK |= (1 << INT0) | (1 << INT1);  // ngat  ngoài 0

#asm("sei")
	alarm_hour = 0;
	alarm_min = 0;
	hour = 23;
	min = 59;
	sec = 45;
	weekday = 3;
	date = 28;
	month = 2;
	year = 23;
	ds1307_Init();


	ds1307_SetTime(sec, min, hour);
	ds1307_SetDate(weekday, date, month, year);

	/* initialize the LCD for 2 lines & 16 columns */
	lcd_i2c_init(PCF8574_I2C_ADDRESS, 16);
	//lcd_backlight(false); // flash the backlight

	while (1)
		{
		//PORTD.4 = 1;
		ds1307_Read();

		if (backlightTimer > 0)
			{
			lcd_backlight(true); // Turn on the backlight
			backlightTimer--; // Decrese remaining backlight timer
			}
		else
			{
			lcd_backlight(false); // Turn off the backlight
			}

		if (count == 2 || count == 3)
			{
			lcd_clear();
			lcd_backlight(true);
			lcd_printfxy(0, 0, "Set hour");
			delay_ms(100);
			lcd_printfxy(0, 0, "Set hour");
			lcd_printfxy(0, 1, "%u", hour);
			delay_ms(300);
			lcd_printfxy(0, 1, "          ");
			delay_ms(300);
			lcd_printfxy(0, 1, "%u", hour);
			}

		else if (count == 4 || count == 5)
			{
			lcd_clear();
			lcd_printfxy(0, 0, "Set minute");
			delay_ms(100);
			lcd_printfxy(0, 0, "Set minute");
			lcd_printfxy(0, 1, "%u", min);
			delay_ms(300);
			lcd_printfxy(0, 1, "          ");
			delay_ms(300);
			lcd_printfxy(0, 1, "%u", min);
			}
		else if (count == 6 || count == 7)
			{
			lcd_clear();
			lcd_printfxy(0, 0, "Set date");
			delay_ms(100);
			lcd_printfxy(0, 0, "Set date");
			lcd_printfxy(0, 1, "%u", date);
			delay_ms(300);
			lcd_printfxy(0, 1, "          ");
			delay_ms(300);
			lcd_printfxy(0, 1, "%u", date);
			}
		else if (count == 8 || count == 9)
			{
			lcd_clear();
			lcd_printfxy(0, 0, "Set month");
			delay_ms(100);
			lcd_printfxy(0, 0, "Set month");
			lcd_printfxy(0, 1, "%u", month);
			delay_ms(300);
			lcd_printfxy(0, 1, "          ");
			delay_ms(300);
			lcd_printfxy(0, 1, "%u", month);
			}
		else if (count == 10 || count == 11)
			{
			lcd_clear();
			lcd_printfxy(0, 0, "Alarm hour");
			delay_ms(100);
			lcd_printfxy(0, 0, "Alarm hour");
			lcd_printfxy(0, 1, "%u", alarm_hour);
			delay_ms(300);
			lcd_printfxy(0, 1, "          ");
			delay_ms(300);
			lcd_printfxy(0, 1, "%u", alarm_hour);
			}
		else if (count == 12 || count == 13)
			{
			lcd_clear();
			lcd_printfxy(0, 0, "Alarm minute");
			delay_ms(100);
			lcd_printfxy(0, 0, "Alarm minute");
			lcd_printfxy(0, 1, "%u", alarm_min);
			delay_ms(300);
			lcd_printfxy(0, 1, "          ");
			delay_ms(300);
			lcd_printfxy(0, 1, "%u", alarm_min);
			}
		else if (count == 14 || count == 15)
			{
			lcd_clear();
			lcd_printfxy(0, 0, "Want an alarm ?");
			delay_ms(100);
			lcd_printfxy(0, 0, "Want an alarm ?");
			if (isAlarm == 0)
				{
				lcd_printfxy(0, 1, "OFF");
				delay_ms(300);
				lcd_printfxy(0, 1, "          ");
				delay_ms(300);
				lcd_printfxy(0, 1, "OFF");
				}
			else if(isAlarm == 1)
				{
				lcd_printfxy(0, 1, "ON");
				delay_ms(300);
				lcd_printfxy(0, 1, "          ");
				delay_ms(300);
				lcd_printfxy(0, 1, "ON");
				}
			}
		else
			{
			// Display time
			if (count == 0 || count == 1)
				{
				ds1307_Read();
				lcd_printfxy(0, 0, "%u:%u:%u          ", hour, min, sec);  //print the counter variable
				lcd_printfxy(0, 1, "%u/%u/%u          ", date, month, year);
				//lcd_backlight(true);
				}
			}

		// Alarm is on
		if (hour == alarm_hour && min == alarm_min && isAlarm == 1)
			{
			PORTD.4 = 1;
			delay_ms(500);
			PORTD.4 = 0;
			delay_ms(500);
			}
		}
}
