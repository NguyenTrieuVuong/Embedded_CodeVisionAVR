/*
 * Tuan 5
 * Nhom 3      
 * Duong Duc Thinh
 * 20002166
 */
#include <mega328p.h>
#define BAUDRATE 9600
#define fosc 16000000

unsigned int n;
unsigned int a;
void putchar(unsigned char data){
    while (!(UCSR0A & 0b00100000)); //Ch? thanh ghi d? li?u Empty
    UDR0 = data;
}

void put_int(unsigned int value){
    unsigned char buf[8];
    int index = 0,i,j;
    j = value;
    do{
        buf[index] = j%10 +48;
        j = j/10;
        index += 1;
    }while(j);
    
    for (i=index ; i>0 ; i--){
        putchar(buf[i-1]);
    }
}

interrupt [TIM1_COMPA] void timer1_compa_isr(void){
    a = TCNT0; 
    put_int(a);    
}

void main(){ 
    // Time 1 chu ki 1s
    TCCR1A = 0b01000000;
    TCCR1B = 0b00001101; 
    //7811
    OCR1AH = 0b00111101;
    OCR1AL = 0b00000110;  
    TIMSK1 = 0b00000010;
    
    //Counter 0
    TCCR0A = 0b00000000;
    TCCR0B = 0b00000101;    
   
    //UART      
    n = fosc/(16*BAUDRATE)-1;
    UBRR0H = n>>8;          
    UBRR0L = n;
            
    UCSR0C = 0b00000110;
    UCSR0B = 0b10011000;
             
    #asm("sei");
    while (1){}
}