#!/bin/bash
#
# Drive Watch
# - Set the drive LED status dependend on the drive state. -
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

