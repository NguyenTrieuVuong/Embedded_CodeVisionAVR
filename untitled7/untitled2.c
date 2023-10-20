#include <mega328p.h>
#define BAUDRATE 9600
#define fOSC 16000000
#include <delay.h>
int n;

//truyen 1 ki tu du lieu 
void putchar(unsigned char data){
    while(!(UCSR0A & 0b00100000));   //cho thanh ghi du lieu EMPTY
    UDR0 = data;
}
//truyen 1 chuoi
void putstring(unsigned char *str){
    while(*str){
        putchar(*str);
        //if see the line feed, add carriage return
        if(*str == '\n')
            putchar('\r');
        str++;
    }
}
//truyen 1 so nguyen
void put_int(unsigned int value){
    unsigned char buf[8];
    int index = 0,i,j;
    j = value;
    do{
       buf[index] = j%10 + 48;     //chuyen gia tri sang ki tu 
       j = j/10;
       index += 1;
    }
    while (j);    
    
    for(i = index; i>0; i--)
    putchar(buf[i-1]);
}
//Vector phuc vu ngat
interrupt [TIM1_OVF] void timer1_ovf_isr(void){
    PORTB.5 = !PORTB.5;
    TCNT1H = 0x85;
    TCNT1L = 0xEE; 
    put_int(TCNT0);
}

void main(void)
{

//UART
    //tinh gia tri baud rate roi dua vao thanh ghi UBRRn
    n = fOSC/(16*BAUDRATE)-1;
    UBRR0H = n>>8;
    UBRR0L = n;
    //cau hinh che do truyen, khung ban tin bang thanh ghi UCSRnC
    UCSR0C = 0b00000110;                //truyen ko dong bo, 8 data bit, 1 stop bit, no parity
    //cho phep ca 2 chieu truyen nhan, cho phep ngat nhan du lieu (RX interrupt)
    UCSR0B = 0b10011000;

//Timer1/Counter0
    CLKPR = (1<<CLKPCE);            //Cho phep chia tan so
    CLKPR = 0x00;                   //Dat he so chia la 1
    
    DDRB != 0b00100000;             //Dat PORTB.5 la OUT
    PORTB &= 0b11011111; 
    DDRB.5 = 1;
    PORTB.5 = 1;
    
    TCCR1A = 0x00;                  //Dat che do Overflow(dem tu vi tri setup den vi tri cuoi)
    
    //Cau hinh nguon chia clock cho timer bang thanh ghi TCCRxB.
    TCCR1B = 0b00000100;            //Clock timer = clockIO/256
    //Dat gia tri ban dau cho thanh ghi TCNTx
    TCNT1H = 0x85;
    TCNT1L = 0xEE;
    TCNT0 = 0;
    
    //Cho phep ngat phu hop bang thanh ghi TIMSKx
    TIMSK1 = 0b00000001;            //Cho phep ngat Overflow
    //Cho phep ngat toan cuc
    #asm("sei")

while (1)
    {
    // Please'/ write your application code here   
      
    }
}