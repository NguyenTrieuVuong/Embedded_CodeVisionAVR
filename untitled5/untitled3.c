/*
 * untitled3.c
 *
 * Created: 3/16/2023 10:45:02 AM
 * Author: admin
 */

#include <mega328p.h>
#include <delay.h>

void main(void)
{
DDRD |= 0b01000000;
PORTD &= 0b10111111;
//TCCR0A = 0b10000011;  // Fast PWM
TCCR0A = 0b10000001;  // PWM phase correct
TCCR0B = 0b00000100;
TCNT0 = 0x00;
OCR0A = 25;
while (1)
    {
    // Please write your application code here
    delay_ms(1000);
    OCR0A +=25;
    if (OCR0A == 255)
       {            
       OCR0A = 25;

       }
    }
}
