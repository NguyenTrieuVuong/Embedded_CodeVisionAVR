/*
 * untitled1.c
 *
 * Created: 3/30/2023 8:46:06 AM
 * Author: admin
 */

#include <mega328p.h>
#include <delay.h>
#include "USART.h"
#include "ADC.h"


#define fosc 16000000UL
#define baudrate 9600
#define baud_prescaler (((fosc/(baudrate*16UL)))-1)

unsigned long adc_value = 0;
unsigned long voltage_val, demi_part, int_part;

/*
void uart_init(void)
{
    int n = baud_prescaler;
    UBRR0H = (n >> 8);
    UBRR0L = n;
    UCSR0C = 0b00000110;
    UCSR0B = 0b10011000; 
    #asm("sei")
}

void uart_transmit(unsigned char data)
{
    while(!(UCSR0A & 0b00100000));

    UDR0 = data;
}

void putint(unsigned int value)
{
    unsigned char buf[8];
    int index = 0, i, j;
    j = value;
    do
        {
        buf[index] = j % 10 + 48;
        j = j / 10;
        index += 1;
        }
    while(j);
    for (i = index; i > 0; i--)
        uart_transmit(buf[i - 1]);
}

void putstring(unsigned char *str)
{
    while(*str)
        {
        uart_transmit(*str);
        if (*str == '\n')
            uart_transmit('\r');
        str++;
        }
}

void init_adc(void){
    ADMUX |= (1<<REFS0);
    ADCSRA |= 0b10000111;
    DIDR0 |= 0x01;
    delay_ms(10);
    
}
*/

void main(void)
{
uart_init();
ADC_init(1<<REFS0);
while (1)
    {
    // Please write your application code here
    ADCSRA |= 0b01000000;
    while((ADCSRA & 0b00010000) ==0);
    adc_value = ADCW;
    ADCSRA |= 0b00010000;
    putstring("Gia tri ADC: ");
    putint(adc_value);
    putstring("\n");
    voltage_val = adc_value*500/1024;
    putint(voltage_val);
    putstring("\n");
    
    demi_part = voltage_val%100;
    int_part = voltage_val/100;
    putstring("Gia tri dien ap: ");
    putint(int_part);
    putstring(".");
    putint(demi_part);
    putstring(" vol \n");
    delay_ms(3000);
    }
}
