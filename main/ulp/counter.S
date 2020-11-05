#include "soc/rtc_cntl_reg.h"
#include "soc/soc_ulp.h"

    /* Define variables to go into the .bss section (zero-initialised data) */
    .bss

    .global time_reg_1
time_reg_1:
    .long 0

    .global time_reg_2
time_reg_2:
    .long 0

    .global time_reg_3
time_reg_3:
    .long 0


    /* Code goes into the .text section */
    .text
    .global entry
entry:
    READ_RTC_REG(RTC_CNTL_TIME0_REG, 0, 16)
    MOVE R2, time_reg_1
    ST R0, R2, 0

    REG_RD 0x3FF48010, 31, 16
    MOVE R2, time_reg_2
    ST R0, R2, 0

    REG_RD 0x3FF48014, 15, 0
    MOVE R2, time_reg_3
    ST R0, R2, 0

    HALT