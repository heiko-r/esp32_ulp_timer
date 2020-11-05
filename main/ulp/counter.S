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
    /* Trigger update of register */
    WRITE_RTC_REG(RTC_CNTL_TIME_UPDATE_REG, RTC_CNTL_TIME_UPDATE_S, 1, 1)
    JUMP check_time_valid
    

check_time_valid:
    /* Check if RTC_CNTL_TIME_VALID bit is one, otherwise repeat */
    READ_RTC_REG(RTC_CNTL_TIME_UPDATE_REG, RTC_CNTL_TIME_VALID_S, 1)
    AND R0, R0, 1
    JUMP check_time_valid, EQ
    
    /* Read timer registers */
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