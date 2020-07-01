PORT ?= 0
REDUCE_SPEED ?= 0

CFLAGS += \
  -flto \
  -mthumb \
  -mabi=aapcs \
  -mcpu=cortex-m7 \
  -mfloat-abi=hard \
  -mfpu=fpv5-d16 \
  -nostdlib -nostartfiles \
  -DSTM32F746xx \
  -DHSE_VALUE=25000000 \
  -DCFG_TUSB_MCU=OPT_MCU_STM32F7 \
  -DBOARD_DEVICE_RHPORT_NUM=$(PORT)

ifeq ($(PORT), 1)
 ifeq ($(REDUCE_SPEED), 0)
CFLAGS += -DBOARD_DEVICE_RHPORT_SPEED=OPT_MODE_HIGH_SPEED
$(info "Using OTG_HS in HS mode")
 else
CFLAGS += -DBOARD_DEVICE_RHPORT_SPEED=OPT_MODE_FULL_SPEED
$(info "Using OTG_HS in FS mode")
 endif
else
$(info "Using OTG_FS")
endif

# mcu driver cause following warnings
CFLAGS += -Wno-error=shadow -Wno-error=cast-align

ST_HAL_DRIVER = hw/mcu/st/st_driver/STM32F7xx_HAL_Driver
ST_CMSIS = hw/mcu/st/st_driver/CMSIS/Device/ST/STM32F7xx

# All source paths should be relative to the top level.
LD_FILE = hw/bsp/$(BOARD)/STM32F746ZGTx_FLASH.ld

SRC_C += \
	$(ST_CMSIS)/Source/Templates/system_stm32f7xx.c \
	$(ST_HAL_DRIVER)/Src/stm32f7xx_hal.c \
	$(ST_HAL_DRIVER)/Src/stm32f7xx_hal_cortex.c \
	$(ST_HAL_DRIVER)/Src/stm32f7xx_hal_rcc.c \
	$(ST_HAL_DRIVER)/Src/stm32f7xx_hal_rcc_ex.c \
	$(ST_HAL_DRIVER)/Src/stm32f7xx_hal_gpio.c \
	$(ST_HAL_DRIVER)/Src/stm32f7xx_hal_uart.c \
	$(ST_HAL_DRIVER)/Src/stm32f7xx_hal_pwr_ex.c

SRC_S += \
	$(ST_CMSIS)/Source/Templates/gcc/startup_stm32f746xx.s

INC += \
	$(TOP)/hw/mcu/st/st_driver/CMSIS/Include \
	$(TOP)/$(ST_CMSIS)/Include \
	$(TOP)/$(ST_HAL_DRIVER)/Inc \
	$(TOP)/hw/bsp/$(BOARD)

# For TinyUSB port source
VENDOR = st
CHIP_FAMILY = synopsys

# For freeRTOS port source
FREERTOS_PORT = ARM_CM7/r0p1

# flash target using on-board stlink
flash: flash-stlink
