#include <mega328p.h>
#include <delay.h>

#define ADC_VREF_TYPE ((0<<REFS1) | (1<<REFS0) | (0<<ADLAR))

void ADC_init(unsigned char input){
    ADMUX = ADC_VREF_TYPE | input;
    ADCSRA = 0b10000111;
    DIDR0 |= 0x01<<input;
    delay_ms(10);
}

unsigned int ADC_read(unsigned char input){
    ADMUX = ADC_VREF_TYPE | input;
    DIDR0 |= 0x01<<input;
    delay_ms(10);
    ADCSRA = 0b01000000;
    while((ADCSRA & 0b00010000)==0);
    ADCSRA |= 0b00010000;
    return ADCW;
}
