/* Reset Controller 

Initially, the peripherals on the rp2040 not required to boot are held in a reset state. We can interact with the reset controller to control this behavior.

In STEP 1, we will clear the reset on iobank_0 and PIO0 
In STEP 2, we will check whether the resets were successful, and infinite loop if not

IMPORTANT:
Using this in the future: Simply just change the value being moved to r6 with the correct necessary items.

equates:
    rst_base: base register for clearing reset controller
    rst_clr: atomic register for clearing reset controller
    rst_done: register to check for successful reset done
*/

.equ rst_base, 0x4000c000
.equ rst_clr, rst_base + 0x3000 
.equ rst_done, rst_base + 0x8

// STEP 1
    ldr r7, =rst_clr
    ldr r6, =0b1<<5 | 0b1<<10
    str r6, [r7]

// STEP 2
    ldr r7, =rst_done
rst:
    ldr r5, [r7]
    and r5, r6
    beq rst
