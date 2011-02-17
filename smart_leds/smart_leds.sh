#!/bin/bash
#
# SMART LEDs
# - Set the drive LED status depend on the SMART status. -
# Copyright (C) 2011, Sven Bachmann <dev@mcbachmann.de>
#
# This program is free software; you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation; either version 2 of the License.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
# details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#

DRIVES=( sdc sdd sde sdf )
LEDS=( hdd1 hdd2 hdd3 hdd4 )

for cnt in `seq 0 3`; do
    echo 0 > /sys/class/leds/${LEDS[$cnt]}\:amber\:sata/blink
    echo 0 > /sys/class/leds/${LEDS[$cnt]}\:blue\:sata/brightness
    echo 0 > /sys/class/leds/${LEDS[$cnt]}\:amber\:sata/brightness
    rm -f /var/lock/hdd_led_${DRIVES[$cnt]}
done

while [ 1 ]; do
for cnt in `seq 0 3`; do
    if [ "`smartctl --attributes /dev/${DRIVES[$cnt]} | grep 197 | cut -d' ' -f 34-`" -ne "0" -o \
         "`smartctl --attributes /dev/${DRIVES[$cnt]} | grep 198 | cut -d' ' -f 34-`" -ne "0" ]; then
        touch /var/lock/hdd_led_${DRIVES[$cnt]}
        sleep 1
        echo 0 > /sys/class/leds/${LEDS[$cnt]}\:blue\:sata/brightness
        echo 1 > /sys/class/leds/${LEDS[$cnt]}\:amber\:sata/blink
        echo 255 > /sys/class/leds/${LEDS[$cnt]}\:amber\:sata/brightness
    else
        if [ -e "/var/lock/hdd_led_${DRIVES[$cnt]}" ]; then
            echo 0 > /sys/class/leds/${LEDS[$cnt]}\:amber\:sata/blink
            echo 0 > /sys/class/leds/${LEDS[$cnt]}\:amber\:sata/brightness
            echo 0 > /sys/class/leds/${LEDS[$cnt]}\:blue\:sata/brightness
            rm -f /var/lock/hdd_led_${DRIVES[$cnt]}
        fi
    fi
done

# sleep 24h, because polling SMART data wakes up some drives
sleep 86400
done

