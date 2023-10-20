/*
 * TWI_Master.c
 *
 * Created: 5/22/2023 11:13:26 PM
 * Author: Tuan Do
 */

#include <mega328p.h>
#include <delay.h>
#include "uart.h"
#include "TWI_Lib.h"

////////////////////////////////////////////////////////////
#define own_address 2
#define slave_address 1


////////////////////////////////////////////////////////////
unsigned char TWI_Rx_Buf[50];
unsigned char TWI_Tx_Buf[50];
unsigned char UART_Rx_Buf[50];
unsigned char test[] = {1,2,3,4};
int i, UART_Rx_Index = 0, UART_Data_In = 0;
int TWI_Rx_Index = 0, TWI_Tx_Index = 0, TWI_Data_In = 0;
unsigned char Status_Code;

///////// Interrupt Routines //////////////////////////////
interrupt [USART_RXC] void usart_rx_isr(void) {
    UART_Data_In = 1;
    if (UART_Rx_Index <50){
    UART_Rx_Buf[UART_Rx_Index++] = UDR0;
    }    
}
///////////////

////////////// TWI Interupt //////////
interrupt [TWI] void TWI_isr(void){
    Status_Code = TWSR;
    switch (Status_Code){
////////////////////////////////////////////////////
///////////// Slave Receive Mode ///////////////////
    case 0x60:                   //Own Address match + W, sent ACK
        uart_putstring("Own address match + W \n");
        TWI_Rx_Index = 0;
        TWCR |= 0b11000000;     //Clear TWINT, set TWEA
        break;
    case 0x80:                  //Received a byte, sent ACK
        
        uart_putstring("Receive a byte, sent ACK \n");
        if (TWI_Rx_Index<49){ 
            TWI_Rx_Buf[TWI_Rx_Index++] = TWDR;
            TWCR |= 0b11000000;     //Clear TWINT, set TWEA
            break;
        }
        else {                  //Receive last byte
            TWI_Rx_Buf[TWI_Rx_Index] = TWDR;
            TWCR = 0b10000101;     //Clear TWINT, clear TWEA, send NACK
            break;
        }
    case 0x88:                  //Received a byte, sent NACK
        TWCR |= 0b11000000;     //Clear TWINT, set TWEA
        break;
    // For General Call   
    case 0x70:                  //General Call match + W, send ACK
        TWI_Rx_Index = 0;
        TWCR |= 0b11000000;     //Clear TWINT, set TWEA
        break;
    case 0x90:                  //Received a byte, sent ACK
        
        if (TWI_Rx_Index<49){ 
            TWI_Rx_Buf[TWI_Rx_Index++] = TWDR;
            TWCR |= 0b11000000;     //Clear TWINT, set TWEA
            break;
        }
        else {                  //Receive last byte
            TWI_Rx_Buf[TWI_Rx_Index] = TWDR;
            TWCR = 0b10000101;     //Clear TWINT, clear TWEA, send NACK
            break;
        }
    case 0x98:                  //Received a byte, sent NACK
        uart_putstring("Receive a byte, sent NACK \n");
        TWCR |= 0b11000000;     //Clear TWINT, set TWEA
        break;
    case 0xA0:                  //Received Stop condition or Restart
        uart_putstring("Receive Stop condition \n");
        TWI_Data_In = 1;
        TWCR |= 0b11000000;     //Clear TWINT, set TWEA
        break;
//////////////////////////////////////////////////////
///////////// Slave Transmit Mode ///////////////////    
    case 0xA8:                  //Own Address match + R,  sent ACK
        TWDR = TWI_Tx_Buf[TWI_Tx_Index++];
        TWCR |= 0b11000000;     //Clear TWINT, set TWEA
        break;
    case 0xB8:                  //Sent data, received ACK
        if (TWI_Tx_Index < 49){
            TWDR = TWI_Tx_Buf[TWI_Tx_Index++];
            TWCR |= 0b11000000;     //Clear TWINT, set TWEA
            break;
        }
        else {
            TWDR = TWI_Tx_Buf[TWI_Tx_Index];    //send last byte
            TWCR = 0b10000101;                  //Clear TWINT, Clear TWEA
            break;
        }
    case 0xB0:           //Lost arbitration, own address match+R, sent ACK
        TWDR = TWI_Tx_Buf[TWI_Tx_Index++];
        TWCR |= 0b11000000;     //Clear TWINT, set TWEA
        break;
    case 0xC0:                  //sent data byte, receive NACK
        TWCR |= 0b11000000;     //Clear TWINT, set TWEA
        break;
    case 0xC8:                  //sent last data byte, receive ACK
        TWCR |= 0b11000000;     //Clear TWINT, set TWEA
        break;    
    }
}

void main(void)
{
    uart_init(9600);
    TWI_Init(own_address, 1, 100000);
while (1)
    { 
        //If receive data from UART, transfer them into TWI (Master transmit mode)
        if (UART_Data_In) {
            uart_putstring("Data received from UART : ");
            uart_putstring(UART_Rx_Buf);
            uart_putstring("\n");
            //Reset Rx_Buf
            for (i = 0; i<UART_Rx_Index;i++){
                TWI_Tx_Buf[i] = UART_Rx_Buf[i];
                UART_Rx_Buf[i] = 0;
            }
            if (TWI_Master_Send(slave_address,TWI_Tx_Buf,UART_Rx_Index))
                TWI_Error();            
            UART_Rx_Index = 0;
            UART_Data_In = 0;        
        }
        delay_ms(1000);
        
        //If receive data from TWI, transfer them into UART
        if (TWI_Data_In){
            uart_putstring("Data received from TWI: ");
            uart_putstring(TWI_Rx_Buf);
            uart_putstring("\n");
            for (i = 0; i<TWI_Rx_Index;i++)
                TWI_Tx_Buf[i] = 0;                
            TWI_Rx_Index = 0;
            TWI_Data_In = 0;        
        }
    }
}
