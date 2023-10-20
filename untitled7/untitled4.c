#include <mega328p.h>
#include <stdio.h>
#include <delay.h>
#include "USART.h"

// Khai báo bi?n
int adc_value;

// Ng?t Timer 1
interrupt [TIM1_OVF] void timer1_ovf_isr(void)
{
  // Bat co cho chuyen doi ADC tu dong
  ADCSRA |= (1 << ADSC);
  
  // Reset l?i ng?t Timer 1
  TCNT1H = 0xFF;
  TCNT1L = 0xF0;
}

void main(void)
{
  // Khai báo bi?n
  char buffer[10];

  // Kh?i t?o UART v?i baudrate 9600
  uart_init();
  
  // Kh?i t?o Timer 1 v?i t?n s? 1Hz
  TCCR1B = (1 << CS12) | (0 << CS11) | (0 << CS10);
  TCNT1H = 0xFF;
  TCNT1L = 0xF0;
  TIMSK1 |= (1 << TOIE1);

  // Kh?i t?o ADC
  ADMUX = (1 << REFS0) | (0 << REFS1) | (0 << MUX0) | (1 << MUX1) | (0 << MUX2) | (0 << MUX3);
  ADCSRA = (1 << ADEN) | (1 << ADIE) | (1 << ADATE) | (1 << ADPS2) | (1 << ADPS1) | (1 << ADPS0);

  // B?t ng?t toàn c?c
  #asm("sei")

  while (1)
  {
    // Ð?i cho chuy?n d?i ADC k?t thúc
    while ((ADCSRA & (1 << ADIF)) == 0);

    // Ð?c giá tr? ADC
    adc_value = ADCW;

    // Hi?n th? giá tr? ADC trên Terminal
    sprintf(buffer, "%d", adc_value);
    putstring(buffer);
    putstring("\r\n");

    // Reset c? ng?t ADC
    ADCSRA |= (1 << ADIF);

    // Ð?i 100ms
    delay_ms(100);
  }
}
