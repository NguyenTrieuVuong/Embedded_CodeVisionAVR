/*
 * untitled1.c
 *
 * Created: 3/23/2023 9:54:42 AM
 * Author: admin
 */
//#include <stdio.h>
#include <mega328p.h>
#include <delay.h>
#include "USART.h"
#define BAUD 9600
#define fosc 16000000
unsigned int n;
unsigned char rxdata;

/*
void putchar(unsigned char data)
{
	while(!(UCSR0A & 0b00100000));

	UDR0 = data;

}
void putstring(unsigned char *str)
{
    while(*str)
        {
        putchar(*str);
        if (*str == '\n')
            putchar('\r');
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
        putchar(buf[i - 1]);
}
*/
interrupt [USART_RXC] void usart_rx_isr(void)
{
    //rxdata = UDR0;
    //putchar(rxdata);
    //putstring("Nguyen Trieu \nVuong");
    putint(255);
    putstring("\r");
}

void main(void)
{
    uart_init();
    while (1)
        {
        // Please write your application code here
        //putchar(rxdata);
        //delay_ms(1000);
        }
}
