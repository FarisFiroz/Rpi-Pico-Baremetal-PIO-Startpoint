.section .reset, "ax"
.global _start
_start:

.include "src/includes/clocks.s"
.include "src/includes/resets.s"
.include "src/includes/gpio_init.s"

// Global Equate: PIO0 Base Register
.equ pio0_base, 0x50200000

/* PIO State Machine Disable {{{

Here we will disable the state machines before doing anything else

*/
    ldr r7, =pio0_base
    mov r6, #0
    str r6, [r7]


// }}}

// State machine setup
.equ pio0_sm_clkdiv_minus8, pio0_base + 0x0c0
    ldr r7, =pio0_sm_clkdiv_minus8
/* PIO State Machine Clock Divider Setup {{{

Our PIO program will only use one state machine for simplicity; however, we will write code to handle state machine clocks here.

We will use the slowest clock possible for now while still using the XOSC. Essentially, we will divide the 12mhz from the system clock by 65536, creating about a 183Hz clock cycle for the state machine.

// STEP 1: Load the address of the state machine 0 clkdiv register
// STEP 2: Make INT value of divider equal to 0 (this will be interpreted as 65536 by the PIO)
*/

// STEP 1
    add r7, #8

// STEP 2
    mov r6, #0
    str r6, [r7]

// }}}
/* PIO State Machine Execution Control Setup {{{

We would now configure the EXECCTRL register

We will not do so here because the default values are okay

*/

// STEP 1
    add r7, #4

// }}}
/* PIO State Machine Shift Control Setup {{{

We would now configure the SHIFTCTRL register

We will not do so here because the default values are okay

*/

// STEP 1
    add r7, #4

// }}}
/* PIO State Machine Starting Instruction Set {{{

We would now configure the INSTR register

We will not do so here because the default values are okay

*/

// STEP 1
    add r7, #8

// }}}
/* PIO State Machine Pin Control Setup {{{

We can now control the pin setups of the PIO block.

We are currently using gpio 16 and 17. Lets set that up here.

*/

// Increment by 4 to get to this register
    add r7, #4

    ldr r6, =1<<26 | 16<<5 // One pin asserted by set, pin 16 is the lowest pin that will be affected by set
    str r6, [r7]

// }}}

/* PIO Instruction Memory Setup {{{

Here we will create a custom memcpy function that copies halfwords from flash and moves them into the pio instruction memory registers.

*/
.equ pio0_instr_mem0, pio0_base + 0x048 // Instruction memory for pio0

    // Load dest/src mem location and length to copy
    ldr r7, =pio0_instr_mem0 // dest
    ldr r6, =pio0_instructions // src
    mov r5, #(pio0_instructions_end - pio0_instructions) // length

    // memcpy loop
pio_instr_memcpy:
    ldrh r4, [r6] // Load value from src
    str r4, [r7] // Place value into dest
    add r7, #4
    add r6, #2
    sub r5, #2
    bne pio_instr_memcpy

// }}}

/* PIO State Machine Enable {{{

Here we will enable the state machines

*/
    ldr r7, =pio0_base
    mov r6, #1
    str r6, [r7]


// }}}

// {{{ Processor Sleep 
sleep:
    wfi
    b sleep
// }}}

// Data {{{
pio0_instructions:
.hword 0xe081
.hword 0xe101
.hword 0xe000
.hword 0x0001
pio0_instructions_end:
// }}}
