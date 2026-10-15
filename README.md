# Digital Clock and Calendar using ATmega32A

A digital clock and calendar project built with the **ATmega32A microcontroller** using CodeVisionAVR and simulated in Proteus.

The project combines a digital clock with a calendar, displaying time and date information on seven-segment displays. It also allows the user to set the initial values using physical buttons.

## Features

- **Digital Clock:** Displays hours, minutes, and seconds.
- **Digital Calendar:** Displays the day, month, and year.
- **Seven-Segment Display:** Uses multiplexed seven-segment displays to show the time and date.
- **Button Controls:** Three buttons allow the user to increase values, decrease values, and confirm each selection.
- **Timer Interrupts:** Uses Timer1 in CTC mode to handle automatic time updates.
- **Interactive Setup:** Allows the user to set the initial time and date before the clock starts running.

## Technologies Used

- **Microcontroller:** ATmega32A
- **Programming Language:** C
- **IDE:** CodeVisionAVR
- **Simulation:** Proteus
- **Hardware Components:** Seven-segment displays and push buttons

## How It Works

When the system starts, the user can set the initial time and date using three buttons. Each digit is configured individually, and the selected value is displayed on the seven-segment display.

Once the setup is complete, Timer1 generates periodic interrupts to update the clock. The program handles the progression of seconds, minutes, hours, days, months, and years.

The time and date are displayed by enabling each digit one at a time, allowing multiple seven-segment displays to share the same output port.

## What I Learned

Working on this project helped me practice several embedded systems concepts, including:

- Microcontroller GPIO configuration
- Timer configuration and interrupt handling
- Seven-segment display control
- Button input handling
- Digital timekeeping and calendar logic
- Embedded C programming and hardware simulation

## Simulation

The project is designed to run on the ATmega32A and can be tested in Proteus before being implemented on physical hardware.

## Future Improvements

- Improve button handling with proper debouncing.
- Add validation for dates and different month lengths.
- Improve timekeeping accuracy.
- Add support for leap years.
---

This is the final project for the Microprocessor course.
