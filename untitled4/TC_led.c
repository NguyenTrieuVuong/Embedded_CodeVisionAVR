/*
 * TC_led.c
 *
 * Created: 3/7/2023 9:13:35 AM
 * Author: TDStore
 */

#include <mega328p.h>

interrupt [TIM1_OVF] void timer1_ovf_isr (void)
{
    PORTB.5 = !PORTB.5;
}

void main(void)
{
// 1s blink led
TCCR1A = 0x00;       // dat che do Overflow
TCCR1B = 0b00000101; // prescale clk/1024 -> n = 65048 = FE18
TCNT1H = 0xFE;
TCNT1L = 0x18;
TIMSK1 = 0b00000001; // cho phep ngat Overflow
#asm("sei")

DDRB |= 0x20;
PORTB &= 0x19F;

while (1)
    {
    // Please write your application code here

    }
}
