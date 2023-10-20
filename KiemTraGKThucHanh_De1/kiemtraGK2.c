#include <mega328p.h>
#include <delay.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Khai b�o c�c bi?n to�n c?c
int adc_value;
char message[20];

// Khai b�o nguy�n m?u h�m
void adc_init(void);
void uart_init(void);
void uart_send_string(char *string);
void flash_led(int times);

void main(void)
{
	// Khai b�o bien
	char buffer[30];

	// Khoi tao ADC v� UART
	adc_init();
	uart_init();

	// Khoi tao ch�n PD6 l� dau ra
	DDRD.6 = 1;

	while (1)
		{
		// �oc gi� tri ADC tu ch�n ADC5
		ADCSRA |= (1 << ADSC);  // Bat dau chuyen doi ADC
		while (ADCSRA & (1 << ADSC)==0);  // Cho chuyen doi ADC ho�n tat
		adc_value = ADCW;  // Luu gi� tri ADC v�o bien adc_value

		// Xu l� gi� tri ADC v� dieu khien LED v� gui th�ng diep
		if (adc_value > 800)
			{
			sprintf(message, "System Alarm\r\n");  // Tao th�ng diep
			flash_led(8);  // Nhap nh�y d�n 8 lan (4 Hz x 8 = 32 Hz)
			}
		else if(adc_value < 800)
			{
			sprintf(message, "Alarm over\r\n");  // Tao th�ng diep
			PORTD.6 = 0;  // Tat d�n LED
			}
		uart_send_string(message);  // Gui th�ng diep qua UART

		// Cho 100ms truoc khi doc gi� tri ADC lan tiep theo
        ADCSRA |= (1 << ADIF);
		delay_ms(100);
		}
}

// H�m khoi tao ADC
void adc_init(void)
{
	ADMUX = (1 << REFS0) | (1 << MUX2) | (1 << MUX0);  // Chan nguon tham chieu AVCC, chan k�nh ADC5
	ADCSRA = (1 << ADEN) | (1 << ADPS2) | (1 << ADPS1) | (1 << ADPS0);  // Cho ph�p ADC, chia tan so clock l� 128
}

// H�m khoi tao UART
void uart_init(void)
{
	UCSR0A = 0;
	UCSR0B = (1 << RXEN0) | (1 << TXEN0);  // Cho ph�p UART nhan v� gui
	UCSR0C = (1 << UCSZ01) | (1 << UCSZ00);  // �at k�ch thuoc khung truyen l� 8 bit, kh�ng c� bit kiem tra v� bit stop
	UBRR0H = 0;
	UBRR0L = 8;  // Thiet lap toc do baud = 115200
}

// H�m gui chuoi th�ng diep qua UART
void uart_send_string(char *string)
{
	while (*string != '\0')
		{
		while ((UCSR0A & (1 << UDRE0)) == 0); // Cho den khi c� the gui k� tu
		UDR0 = *string; // Gui k� tu
		string++; // Tang con tro de gui k� tu tiep theo
		}
}

// H�m nhap nh�y d�n LED
void flash_led(int times)
{
	int i;

	for (i = 0; i < times; i++)
		{
		PORTD.6 = 1; // Bat d�n LED
		delay_ms(125); // Cho 125ms (4 Hz)
		PORTD.6 = 0; // Tat d�n LED
		delay_ms(125); // Cho 125ms (4 Hz)
		}
}