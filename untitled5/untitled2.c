/*
 * untitled2.c
 *
 * Created: 3/16/2023 9:28:45 AM
 * Author: admin
 */

#include <mega328p.h>

interrupt [TIM0_COMPA] void timer0_compa_isr(void)
{

	PORTD.5 = !PORTD.5;
}
void main(void)
{
	CLKPR = (1 << CLKPCE);
	CLKPR = 0b00000101;  // divider 32
    // set PD6 as output
    DDRD |= 0b01100000;
    PORTD = 0x00;
    // Configure Timer 0 in CTC mode, prescaler = 1024, Output freq = 1Hz      
    TCCR0A = 0b01000010;
    TCCR0B = 0b00000101;
    OCR0A = 244;  // 500000/(2*1024)
    
    // TIMSK and global enable interrupts
    TIMSK0 = 0b00000010;
    #asm("sei")
    
	while (1)
		{
		// Please write your application code here

		}
}
