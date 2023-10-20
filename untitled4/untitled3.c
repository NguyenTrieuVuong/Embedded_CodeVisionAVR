/*
 * untitled3.c
 *
 * Created: 3/9/2023 9:45:19 AM
 * Author: admin
 */

#include <mega328p.h>
#include <stdbool.h>

void blinkled(unsigned int cycle)
{
	unsigned int n, val;
	val = cycle * 16000000 / (2 * 1024);
	n = 65536 - val;
	TCNT1L = n;
	TCNT1H = n >> 8;
}

bool led = true;
interrupt [TIM1_OVF] void timer1_ovf_isr(void)

{
	if (led)
		{
		PORTB.5 = 0;
		blinkled(2);
		led = false;
		}
	else
		{
		PORTB.5 = 1;
		blinkled(4);
        	led = true;
		}
}

void main(void)
{
	CLKPR = (1 << CLKPCE);
	CLKPR = 0b00000000;      // Dat he so chia la 1
	DDRB |= 0b00100000;
	PORTB &= 0b11011111;
	TCCR1A = 0x00;
	TCCR1B = 0b00000101;
	blinkled(1);
	//TCNT1H = 0xFE;
	//TCNT1L = 0x18;
	TIMSK1 = 0b00000001;
#asm("sei")
	while (1)
		{
		// Please write your application code here

		}
}
