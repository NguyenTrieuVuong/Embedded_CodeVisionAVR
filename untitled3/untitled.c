#include <mega328p.h>
#include <delay.h>

// Define prescaler value for timer1
#define TIMER1_PRESCALER_VALUE 8

// Define the target count for timer1
#define TIMER1_TARGET_COUNT 31250 // 1 second at 8 MHz with prescaler of 8

void main() {
    // Initialize timer1 for normal mode with no output compare or input capture
    TCCR1A = 0x00;
    TCCR1B = (1 << CS11) | (0 << CS10); // Set prescaler to 8

    // Set the initial timer1 count to 0
    TCNT1H = 0x00;
    TCNT1L = 0x00;

    // Wait for timer1 to reach the target count
    while ((TCNT1H << 8) | TCNT1L < TIMER1_TARGET_COUNT);

    // Do something after 1 second has elapsed
    PORTB.5 = 1; // Set pin B0 high
    #asm("sei")


    while (1) {
        // Do nothing
    }
}
