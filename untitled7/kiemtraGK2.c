#include <mega328p.h>
#include <delay.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Khai báo các bi?n toàn c?c
int adc_value;
char message[20];

// Khai báo nguyên m?u hàm
void adc_init(void);
void uart_init(void);
void uart_send_string(char *string);
void flash_led(int times);

void main(void)
{
	// Khai báo bien
	char buffer[30];

	// Khoi tao ADC và UART
	adc_init();
	uart_init();

	// Khoi tao chân PD6 là dau ra
	DDRD.6 = 1;

	while (1)
		{
		// Ðoc giá tri ADC tu chân ADC5
		ADCSRA |= (1 << ADSC);  // Bat dau chuyen doi ADC
		while (ADCSRA & (1 << ADSC)==0);  // Cho chuyen doi ADC hoàn tat
		adc_value = ADCW;  // Luu giá tri ADC vào bien adc_value

		// Xu lý giá tri ADC và dieu khien LED và gui thông diep
		if (adc_value > 800)
			{
			sprintf(message, "System Alarm\r\n");  // Tao thông diep
			flash_led(8);  // Nhap nháy dèn 8 lan (4 Hz x 8 = 32 Hz)
			}
		else if(adc_value < 800)
			{
			sprintf(message, "Alarm over\r\n");  // Tao thông diep
			PORTD.6 = 0;  // Tat dèn LED
			}
		uart_send_string(message);  // Gui thông diep qua UART

		// Cho 100ms truoc khi doc giá tri ADC lan tiep theo
        ADCSRA |= (1 << ADIF);
		delay_ms(100);
		}
}

// Hàm khoi tao ADC
void adc_init(void)
{
	ADMUX = (1 << REFS0) | (1 << MUX2) | (1 << MUX0);  // Chan nguon tham chieu AVCC, chan kênh ADC5
	ADCSRA = (1 << ADEN) | (1 << ADPS2) | (1 << ADPS1) | (1 << ADPS0);  // Cho phép ADC, chia tan so clock là 128
}

// Hàm khoi tao UART
void uart_init(void)
{
	UCSR0A = 0;
	UCSR0B = (1 << RXEN0) | (1 << TXEN0);  // Cho phép UART nhan và gui
	UCSR0C = (1 << UCSZ01) | (1 << UCSZ00);  // Ðat kích thuoc khung truyen là 8 bit, không có bit kiem tra và bit stop
	UBRR0H = 0;
	UBRR0L = 8;  // Thiet lap toc do baud = 115200
}

// Hàm gui chuoi thông diep qua UART
void uart_send_string(char *string)
{
	while (*string != '\0')
		{
		while ((UCSR0A & (1 << UDRE0)) == 0); // Cho den khi có the gui ký tu
		UDR0 = *string; // Gui ký tu
		string++; // Tang con tro de gui ký tu tiep theo
		}
}

// Hàm nhap nháy dèn LED
void flash_led(int times)
{
	int i;

	for (i = 0; i < times; i++)
		{
		PORTD.6 = 1; // Bat dèn LED
		delay_ms(125); // Cho 125ms (4 Hz)
		PORTD.6 = 0; // Tat dèn LED
		delay_ms(125); // Cho 125ms (4 Hz)
		}
}