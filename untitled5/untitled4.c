/*
 * untitled2.c
 *
 * Created: 3/16/2023 9:28:45 AM
 * Author: admin
 */

#include <mega328p.h>

void blinkled(unsigned int cycle){
    unsigned int val;
    val = 16000000/(2*1024*cycle);
    OCR1AH = val;
    OCR1AL = val >> 8;    
}
interrupt [TIM1_COMPA] void timer1_compa_isr(void)
{

	PORTB.5 = !PORTB.5;
    blinkled(1);
}
void main(void)
{
	CLKPR = (1 << CLKPCE);
	CLKPR = 0b00000101;
    DDRB |= 0b00000010;
    PORTB &= 0b11111101;    
    TCCR1A = 0b10000010;
    TCCR1B = 0b00011101;
    //OCR1A = 244;  // 500000/(2*1024)
    blinkled(1);
    
    // TIMSK and global enable interrupts
    TIMSK0 = 0b00000010;
    #asm("sei")
    
    while (1)
        {
        // Please write your application code here

        }
}
