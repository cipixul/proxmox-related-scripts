#!/bin/bash
# script tries to detect all hdds/ssds/nvmes and sets the appropriate scheduler
# install it as a startup script in crontab like:
# crontab -e
# @reboot /path/to/set_io_scheduling.sh
# making sure it's +x

# there are some redundant calls due to the fact that lsblk uses \t
# and the nature of the script is so simple that I didn't feel more time invested is appropriate

modprobe bfq || exit $?
base_list=`lsblk -ilo NAME,TYPE,MODEL,ROTA|grep disk`

echo setting the appropriate scheduler based on disk type

for i in `lsblk -ilo NAME,TYPE,MODEL,ROTA|grep disk|awk '{print $1}'`; do
        device_name=$i
        device_type=`lsblk -ilo NAME,TYPE,ROTA|grep disk|grep $i|awk '{print $3}'`
        echo -n "$device_name : $device_type : "
        if [ $device_type == 0 ]; then
                device_type_human="ssd/nvme"
                scheduler="none"
        else
                device_type_human="sas"
                scheduler="bfq"
        fi

        echo "$device_type_human with $scheduler"
        echo $scheduler > /sys/block/$device_name/queue/scheduler
done

#echo bfq > /sys/block/sda/queue/scheduler
