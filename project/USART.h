/*
 * untitled1.c
 *
 * Created: 3/23/2023 9:54:42 AM
 * Author: admin
 */
//#include <stdio.h>
#include <mega328p.h>
#include <delay.h>
#define BAUD 9600
#define fosc 16000000UL
#define baud_prescaler (((fosc/(BAUD*16UL)))-1)
unsigned char rxdata;


void uart_transmit(unsigned char data)
{
    while(!(UCSR0A & 0b00100000));

    UDR0 = data;

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
/*
interrupt [USART_RXC] void usart_rx_isr(void)
{
    rxdata = UDR0;
    //uart_transmit(rxdata);
    //putstring("Nguyen Trieu \nVuong");
    putint(255);
}
*/

void uart_init(void)
{
    UBRR0H = (baud_prescaler >> 8);
    UBRR0L = baud_prescaler;
    UCSR0C = 0b00000110;
    UCSR0B = 0b10011000;
#asm("sei")
}
