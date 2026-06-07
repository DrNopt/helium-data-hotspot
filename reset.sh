#!/usr/bin/env bash
GPIO_CHIP="gpiochip0"
RESET_GPIO=17
POWER_EN_GPIO=18

echo "Concentrator enabled through ${GPIO_CHIP}:${POWER_EN_GPIO}"
gpioset ${GPIO_CHIP} ${POWER_EN_GPIO}=1
sleep 0.1

echo "Concentrator reset through ${GPIO_CHIP}:${RESET_GPIO}"
gpioset ${GPIO_CHIP} ${RESET_GPIO}=0
sleep 0.1
gpioset ${GPIO_CHIP} ${RESET_GPIO}=1
sleep 0.1
gpioset ${GPIO_CHIP} ${RESET_GPIO}=0
sleep 0.1

exit 0
