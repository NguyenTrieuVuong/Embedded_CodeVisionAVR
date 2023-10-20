/*//////////////////
This is library for TWI comunication in AVR ATmega328p
Created by Tuan Do
*/////////////////
#ifndef _TWILIB_
#define _TWILIB_

#include <mega328p.h>
#include <delay.h>
#include "uart.h"


#define fcpu 16000000
#define BR400   12   
#define BR200   32 
#define BR100   72

//Global variables

int i;

void TWI_Init(char sla,char gcall, char sclock){
    //sla can take value of 1 to 127
    //gcall can take value of 0 or 1
    //sclock <= 400000
    //Assign slave address
    TWAR = (sla<<1) + gcall;
    //Set up the sclock
    TWSR &= 0b11111100;     //TWI prescale  = 1
    TWBR = (unsigned char)((fcpu/sclock -16)/2);
    //Enable TWI, enable TWI interupt, enable ACK
    TWCR = 0b01000101;
} 

void TWI_Interupt_Enable(void){
    TWCR |= 0b00000001;
}
///////////////////////////////////////////
void TWI_Interupt_Disable(void){
    TWCR &= 0b11111110;
}
/////////////////////////////////////////////
unsigned char TWI_Start(void){
    
    TWCR = 0b10100100;
    while (!(TWCR & 0b10000000));
    uart_putstring("Start sent...\n");
    uart_putstring("Status Code: ");
    uart_put_int((unsigned int)(TWSR & 0xF8));
    uart_putstring("\n");
    
    return (TWSR & 0xF8);
    }     
/////////////////////////////////////////////
void TWI_Stop(void) {
    TWCR = 0b10010100;
    } 
/////////////////////////////////////////////////////    
unsigned char TWI_SLA_RW(unsigned char add, unsigned char rw){
    //add is slave address = 0 .. 127
    //rw = 0 -> write data; rw = 1 -> Read data
    TWDR = add<<1 + rw;
    TWCR = 0b10000100;
    while (!(TWCR & 0b10000000));
    uart_putstring("SLA + rw sent ...\n");
    uart_putstring("Status Code: ");
    uart_put_int((unsigned int)(TWSR & 0xF8));
    uart_putstring("\n");
    return (TWSR & 0xF8); 

}
////////////////////////////////////////
unsigned char TWI_Send_Byte(unsigned char b){
    TWDR = b;
    TWCR = 0b10000100;
    while (!(TWCR & 0b10000000));
    uart_putstring("Byte sent...\n");
    uart_putstring("Status Code: ");
    uart_put_int((unsigned int)(TWSR & 0xF8));
    uart_putstring("\n");
    return (TWSR & 0xF8); 
}
/////////////////////////////////////////
unsigned char TWI_Send_Array(unsigned char* arr, int length){
    for (i = 0; i < length; i++){        
        if (TWI_Send_Byte(arr[i]) != 0x28) 
        return (TWSR & 0xF8);
    }
    return (TWSR & 0xF8);  
}
/////////////////////////////////////////
//Process error when transmision
void TWI_Error(void){
    //Send Stop condition to stop the communication
    TWI_Stop();
    //Enable TWI interupt to jump in slave mode
    TWI_Interupt_Enable(); 
}
/////////////////////////////////////////
unsigned char TWI_Master_Send(unsigned char sla, unsigned char* arr, 
                                int length){
   //return 0: Send successfully
   //return 1: Error
   TWI_Interupt_Disable();
   if (TWI_Start() != 0x08){
   
   return 1;                
   }
   if (TWI_SLA_RW(sla,0) != 0x18)
   return 1;
   if (TWI_Send_Array(arr, length) != 0x28)
   return 1;
   //Send Stop condition to stop the communication
   TWI_Stop();
   //Enable TWI interupt to jump in slave mode
   TWI_Interupt_Enable();
   return 0;
} 
/////////////////////////////////////////
unsigned char TWI_Master_Receive(unsigned char sla, unsigned char* arr, 
                                int length){
   //return 0: Receive successfully
   //return 1: Error
   TWI_Interupt_Disable();
   if (TWI_Start() != 0x08)
    return 1; 
   if (TWI_SLA_RW(sla,1) != 0x40)
    return 1;
   for (i = 0; i < (length-1); i++){
    TWCR = 0b11000100;               //Clear TWINT, set TWEA to start reading
    while (!(TWCR & 0b10000000));    //Wait for TWINT is set
    if ((TWSR & 0xF8)!= 0x50)        //Check the status code
        return 1;
    arr[i] = TWDR;
   }
   //Receive last byte
   TWCR = 0b10000100;   //Clear TWINT, clear TWEA to read last byte, not ack
   while (!(TWCR & 0b10000000));    //Wait for TWINT is set
   if ((TWSR & 0xF8)!= 0x58)        //Check the status code
        return 1;
   arr[length-1] = TWDR;
   //Send Stop condition to stop the communication
   TWI_Stop();
   //Enable TWI interupt to jump in slave mode
   TWI_Interupt_Enable();
   return 0;       
}

#endif 