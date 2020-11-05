/* Hello World Example

   This example code is in the Public Domain (or CC0 licensed, at your option.)

   Unless required by applicable law or agreed to in writing, this
   software is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
   CONDITIONS OF ANY KIND, either express or implied.
*/
#include <stdio.h>
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "esp32/ulp.h"
#include "ulp_main.h"

extern const uint8_t ulp_main_bin_start[] asm("_binary_ulp_main_bin_start");
extern const uint8_t ulp_main_bin_end[]   asm("_binary_ulp_main_bin_end");

void app_main(void)
{
    printf("Hello world!\n");

    /* Load ULP binary */
    esp_err_t err = ulp_load_binary(0, ulp_main_bin_start,
        (ulp_main_bin_end - ulp_main_bin_start) / sizeof(uint32_t));
    ESP_ERROR_CHECK(err);

    /* Set ULP wake up period to T = 20ms. */
    ulp_set_wakeup_period(0, 20000);

    /* Start ULP program (ulp_entry corresponds to the 'entry' symbol in
     * counter.S, which is automatically declared in ulp_main.h)
     */
    err = ulp_run(&ulp_entry - RTC_SLOW_MEM);
    ESP_ERROR_CHECK(err);

    const TickType_t xDelay = 1000 / portTICK_PERIOD_MS;
    while (true) {
        vTaskDelay(xDelay);
        printf("time_reg_1: %10d\n", ulp_time_reg_1 & UINT16_MAX);
        printf("time_reg_2: %10d\n", ulp_time_reg_2 & UINT16_MAX);
        printf("time_reg_3: %10d\n", ulp_time_reg_3 & UINT16_MAX);
    }
}
