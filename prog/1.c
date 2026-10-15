#include <mega32a.h>
#include <delay.h>

#define BUTTON_INC_PIN 0   // Button to increase counter (connected to PA0)
#define BUTTON_DEC_PIN 1   // Button to decrease counter (connected to PA1)
#define BUTTON_BREAK_PIN 2 // Button to break the loop (connected to PA2)

int is_button_pressed(int pin)
{
    if (pin == 0)
    {
        // Check if the button connected to BUTTON_INC_PIN (PA0) is pressed
        if (PINA & (1 << BUTTON_INC_PIN)) == 0)
        {
            return 1; // Button is pressed
        }
        else
        {
            return 0; // Button is not pressed
        }
    }
    else if (pin == 1)
    {
        // Check if the button connected to BUTTON_DEC_PIN (PA1) is pressed
        if (PINA & (1 << BUTTON_DEC_PIN)) == 0)
        {
            return 1; // Button is pressed
        }
        else
        {
            return 0; // Button is not pressed
        }
    }
    else if (pin == 2)
    {
        // Check if the button connected to BUTTON_BREAK_PIN (PA2) is pressed
        if (PINA & (1 << BUTTON_BREAK_PIN)) == 0)
        {
            return 1; // Button is pressed
        }
        else
        {
            return 0; // Button is not pressed
        }
    }
    return 0; // default return if none of the pins match
}

const int sevenSegment[] = {
    0xC0,0xF9,0xA4,0xB0,0x99,0x92,0x82,0xF8,0x80,0x90
};

int dayy = 0;
int dayd = 0;

int mony = 0;
int mond = 0;

int yeary = 0;
int yeard = 0;
int years = 0;
int yearh = 0;

int secy = 0;
int secd = 0;

int miny = 0;
int mind = 0;

int hry = 0;
int hrd = 0;

void timer1_init() {
    // Initialize Timer 1 in CTC mode
    TCCR1A = 0x00;
    TCCR1B = 0x0C; // CTC mode, prescaler = 256
    OCR1AH = 0x3D;
    OCR1AL = 0x09; // Set compare value for 1Hz (assuming 16MHz clock)
    TIMSK = 0x10; // Enable Timer1 compare A interrupt
    #asm("sei") // Enable global interrupts
}

void increase_func()
{
    secy++;
    if (secy == 10)
    {
        secd++;
        secy = 0;
        if (secd == 6)
        {
            miny++;
            secd = 0;
            secy = 0;

            if (miny == 10)
            {
                mind++;
                miny = 0;
                if (mind == 6)
                {
                    hry++;
                    miny = 0;
                    mind = 0;
                    if (hry == 10)
                    {
                        hrd++;
                        hry = 0;
                    }
                    if (hrd == 2 && hry == 4)
                    {
                        dayy++;
                        hrd = 0;
                        hry = 0;
                        if (dayy == 10)
                        {
                            dayd++;
                            dayy = 0;
                        }
                        if (dayd == 3 && dayy == 1)
                        {
                            mony++;
                            dayd = 0;
                            dayy = 0;
                            if (mony == 10)
                            {
                                mond++;
                                mony = 0;
                            }
                            if (mond == 1 && mony == 2)
                            {
                                mond = 0;
                                mony = 0;
                                yeary++;
                                if (yeary == 10)
                                {
                                    yeary = 0;
                                    yeard++;
                                    if (yeard == 10)
                                    {
                                        yeard = 0;
                                        years++;
                                        if (years == 10)
                                        {
                                            years = 0;
                                            yearh++;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

interrupt [TIM1_COMPA] void timer1_compa_isr(void)  {
    increase_func();
}

int getval(int max)
{
    int cntr = 0;
    while (1)
    {
        if (is_button_pressed(BUTTON_INC_PIN))
        {
            delay_ms(300);
            if (cntr < max)
            {
                cntr++; // Increase counter
            }
        }

        // Check if the button to decrease the counter (PA1) is pressed
        if (is_button_pressed(BUTTON_DEC_PIN))
        {
            delay_ms(300);
            if (cntr > 0)
            {
                cntr--; // Decrease counter (if greater than zero)
            }
        }

        // Check if the button to break the loop (PA2) is pressed
        if (is_button_pressed(BUTTON_BREAK_PIN))
        {
            delay_ms(300);
            break; // Break out of the loop
        }

        PORTB = sevenSegment[cntr];
        delay_ms(200);
    }
    delay_ms(200);
    return cntr;
}

void main(void)
{
    int select = 0;
    int reset = 1;
    
    // Input/Output Ports initialization
    DDRA = 0x00; // All input
    PORTA = 0x00; // No pull-up resistors

    DDRB = 0x7F; // All output except bit 7
    PORTB = 0x00; // All low

    DDRC = 0xFF; // All output
    PORTC = 0x00; // All low

    DDRD = 0x3F; // All output except bits 6 and 7
    PORTD = 0x00; // All low

    while (1)
    {
        if (reset)
        {
            // tens hour
            PORTC .0 = 1;
            hrd = getval(2);
            PORTC .0 = 0;

            // units hour
            PORTC .1 = 1;
            hry = getval(9);
            PORTC .1 = 0;

            PORTC .2 = 1;
            mind = getval(5);
            PORTC .2 = 0;

            PORTC .3 = 1;
            miny = getval(9);
            PORTC .3 = 0;

            PORTC .4 = 1;
            secd = getval(5);
            PORTC .4 = 0;

            PORTC .5 = 1;
            secy = getval(9);
            PORTC .5 = 0;

            PORTC .6 = 1;
            yearh = getval(9);
            PORTC .6 = 0;

            PORTC .7 = 1;
            years = getval(9);
            PORTC .7 = 0;

            PORTD .0 = 1;
            yeard = getval(9);
            PORTD .0 = 0;

            PORTD .1 = 1;
            yeary = getval(9);
            PORTD .1 = 0;

            PORTD .2 = 1;
            mond = getval(1);
            PORTD .2 = 0;

            PORTD .3 = 1;
            if (mond == 1)
                mony = getval(2);
            else
                mony = getval(9);
            PORTD .3 = 0;

            PORTD .4 = 1;
            dayd = getval(3);
            PORTD .4 = 0;

            PORTD .5 = 1;
            dayy = getval(9);
            PORTD .5 = 0;

            reset = 0;
            timer1_init();
        }

        else if (select == 0)
        {
            PORTC .0 = 1;
            PORTB = sevenSegment[hrd];
            delay_ms(1);
            PORTC .0 = 0;
        }
        else if (select == 1)
        {
            PORTC .1 = 1;
            PORTB = sevenSegment[hry];
            delay_ms(1);
            PORTC .1 = 0;
        }
        else if (select == 2)
        {
            PORTC .2 = 1;
            PORTB = sevenSegment[mind];
            delay_ms(1);
            PORTC .2 = 0;
        }
        else if (select == 3)
        {
            PORTC .3 = 1;
            PORTB

= sevenSegment[miny];
            delay_ms(1);
            PORTC .3 = 0;
        }
        else if (select == 4)
        {
            PORTC .4 = 1;
            PORTB = sevenSegment[secd];
            delay_ms(1);
            PORTC .4 = 0;
        }
        else if (select == 5)
        {
            PORTC .5 = 1;
            PORTB = sevenSegment[secy];
            delay_ms(1);
            PORTC .5 = 0;
        }
        else if (select == 6)
        {
            PORTC .6 = 1;
            PORTB = sevenSegment[yearh];
            delay_ms(1);
            PORTC .6 = 0;
        }
        else if (select == 7)
        {
            PORTC .7 = 1;
            PORTB = sevenSegment[years];
            delay_ms(1);
            PORTC .7 = 0;
        }
        else if (select == 8)
        {
            PORTD .0 = 1;
            PORTB = sevenSegment[yeard];
            delay_ms(1);
            PORTD .0 = 0;
        }
        else if (select == 9)
        {
            PORTD .1 = 1;
            PORTB = sevenSegment[yeary];
            delay_ms(1);
            PORTD .1 = 0;
        }
        else if (select == 10)
        {
            PORTD .2 = 1;
            PORTB = sevenSegment[mond];
            delay_ms(1);
            PORTD .2 = 0;
        }
        else if (select == 11)
        {
            PORTD .3 = 1;
            PORTB = sevenSegment[mony];
            delay_ms(1);
            PORTD .3 = 0;
        }
        else if (select == 12)
        {
            PORTD .4 = 1;
            PORTB = sevenSegment[dayd];
            delay_ms(1);
            PORTD .4 = 0;
        }
        else if (select == 13)
        {
            PORTD .5 = 1;
            PORTB = sevenSegment[dayy];
            delay_ms(1);
            PORTD .5 = 0;
            select = -1;
        }
        select++;
    }
}