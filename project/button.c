/*
 * TC0.c
 *
 * Created: 3/14/2023 8:41:22 AM
 * Author: LeVan
 */

#include <mega328p.h> 
#include <delay.h>
#include <mega328p.h>
#include "USART.h"
int count = 0;


void mode(){
    PORTB.5 = !PORTB.5; 
    count = count+1;
    if(count >5 ){
        count = 0;
    }
    putstring("\n");
    putint(count);
    delay_ms(500);
}
interrupt [EXT_INT0] void external_interrupt_isr(void)
{
  mode();
}
void main(void)
{   
    uart_init();
    DDRB = DDRB|0x20;
    PORTB = PORTB&0x00;
    DDRD &= 0b11111011;   //  D2 l� ng� v�o
    PORTD |= 0b00000100;   

    EICRA |= 0b00000010;  // falling egde
    EICRA &= 0b11111110; 

    EIMSK |= (1 << INT0);  // ngat  ngo�i 0

    #asm("sei")

    /*while (1){
    if (count > 0){
      putString("\n");
      put_int(count);
      count = 0; 
        }
    }*/
  
}



