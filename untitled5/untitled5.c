#include <mega328p.h>

void sang_toi(int prescaler, int sang, int toi){
    int top, compare;
    top = ((sang+toi)*16*1000000)/(2*prescaler) - 1;
    compare = (top*sang)/(sang+toi);
    
    ICR1H = (top >> 8);
    ICR1L = top;
    
    OCR1AH = (compare >> 8);
    OCR1AL = compare;
}
void main(void)
{
	TCCR1A |= (1 << COM1A1) | (1 << WGM11);     // COM1A1 = 1 => non-inverting mode
	// WGM11 = 1 => fast PWM (TOP is set at ICR1)

	TCCR1B |= (1 << WGM13) | (1 << WGM12) | (1 << CS12) | (1 << CS10);
	// WGM13 = WGM12 = 1 => fast PWM (TOP is set at ICR1)
	// CS12 = CS10 => prescale = 1024

	DDRB |= (1 << DDB1);          // Set PortB 1 as Output, PortB 5 as Input
	PORTB = (1 << PORTB1);                      // Pullup Resistor
    sang_toi(1024,1,2);
	while (1)
		{
		// Please write your application code here
		}
}