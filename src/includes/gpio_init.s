/* GPIO Control Register 

We will need to edit the GPIO Control Registers so that they are enabled and controllable by the PIO.

// STEP 0: Load initial vals
// STEP 1: Write GPIO 16 control val
// STEP 1: Write GPIO 17 control val

equates:
    gpio16_ctrl: control register for gpio16
*/
.equ gpio16_ctrl, 0x40014000 + 0x84

// STEP 0
    ldr r7, =gpio16_ctrl
    mov r6, #6
// STEP 1
    str r6, [r7]
// STEP 2
    str r6, [r7, #0x8]
