#!/bin/bash

DRIVES=( sdc sdd sde sdf )
LEDS=( hdd1 hdd2 hdd3 hdd4 )

while [ 1 ]; do
for cnt in `seq 0 3`; do
    if [ ! -e "/var/lock/hdd_led_${DRIVES[$cnt]}" ]; then
        if [ -z "`hdparm -C /dev/${DRIVES[$cnt]} | grep standby`" ]; then
            echo 0 > /sys/class/leds/${LEDS[$cnt]}\:amber\:sata/brightness
            echo 255 > /sys/class/leds/${LEDS[$cnt]}\:blue\:sata/brightness
        else
            echo 0 > /sys/class/leds/${LEDS[$cnt]}\:blue\:sata/brightness
            echo 0 > /sys/class/leds/${LEDS[$cnt]}\:amber\:sata/brightness
        fi
    fi
done
sleep 10
done

