#!/bin/sh
# Updated reset script for kernel 6.x using libgpiod

if [ -z "$2" ]; then
    echo "CONCENTRATOR_RESET_PIN parameter not passed in, using value from the environment (val=${CONCENTRATOR_RESET_PIN})"
else
    CONCENTRATOR_RESET_PIN=$2
fi

WAIT_GPIO() {
    sleep 0.1
}

reset() {
    echo "CoreCell reset through GPIO${CONCENTRATOR_RESET_PIN}..."
    gpioset gpiochip0 ${CONCENTRATOR_RESET_PIN}=1; WAIT_GPIO
    gpioset gpiochip0 ${CONCENTRATOR_RESET_PIN}=0; WAIT_GPIO
}

case "$1" in
    start)
    reset
    ;;
    stop)
    reset
    ;;
    *)
    echo "Usage: $0 {start|stop}"
    exit 1
    ;;
esac

exit 0
