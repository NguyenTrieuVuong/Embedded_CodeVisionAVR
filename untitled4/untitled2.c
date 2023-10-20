#include <mega328p.h>

void blinkled(unsigned int freq)
{
	unsigned int n, val;
	CLKPR = (1 << CLKPCE);
	CLKPR = 0b00000000;
	TCCR1A = 0x00; // Timer1: normal mode
	TCCR1B = 0b00000101; // Timer1: prescaler = 64, start the timer
	val =  16000000 / (freq * 2 * 1024);
	n = 65536 - val;
	TCNT1L = n;
	TCNT1H = n >> 8;
	TIMSK1 |= (1 << OCIE1A); // enable timer1 compare interrupt
#asm("sei")
}

interrupt [TIM1_COMPA] void timer1_compa_isr(void)
{
	PORTB.5 = !PORTB.5; // toggle the LED at PB5
	blinkled(2);
}

void main()
{
	DDRB |= 0b00100000;
	blinkled(2); // blink the LED at 2 Hz
	while (1) { }
}
