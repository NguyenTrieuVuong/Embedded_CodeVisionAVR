#ifndef _UARTLIB_
#define _UARTLIB_

#include <mega328p.h>
#define fosc    16000000
void uart_init(unsigned int BAUDRATE)
{
  //Config BAUD Rate
    unsigned int n = fosc/BAUDRATE/16 - 1;
    UBRR0H = n>>8;
    UBRR0L = n;
//Config mode and data frame 
//Asynchronous mode, 8 data bit, 1 stop bit, no Parity
    UCSR0C = 0b00000110;
//Enable transmiter and receiver, RX interupt
    UCSR0B = 0b10011000;  
    #asm ("sei")
}
void uart_putchar(unsigned char data)
{
	while (!(UCSR0A & 0b00100000)); //wait for data register empty
	UDR0 = data;
}
void uart_putstring(char *str)
{
   while (*str)
   {
        uart_putchar(*str); 
        //if see the line feed, add carriage return
        if (*str == '\n')
        uart_putchar('\r');
        str++;
   }
}
void uart_put_int(unsigned int value)
{
    unsigned char buf[8];
    int index = 0,i,j;
    j = value;
    do {
        buf[index] = j%10 + 48;//chuyen gia tri sang ki tu
        j = j/10;
        index +=1;    
    } while(j);
    
    for (i = index; i>0; i--)
    uart_putchar(buf[i-1]);
}

#endif 