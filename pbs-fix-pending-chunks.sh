#!/bin/bash
# script shamefully copied from the proxmox forum, sorry, lost the link
# script touches all files so you can run garbage collect afterwards and actually get chunks deleted...



base_dir="/mnt/datastore/core-pbs1-pool1/.chunks/"

yesterday=$(date --date="yesterday" '+%Y-%m-%d %H:%M')
total_dirs=$(find "$base_dir" -mindepth 1 -maxdepth 1 -type d | wc -l)
echo "Total directories to process: $total_dirs"
processed=0

find "$base_dir" -mindepth 1 -maxdepth 1 -type d | while read dir; do
    touch -a -c -d "$yesterday" "$dir/*"
    ((processed++))
    percentage=$(($processed * 100 / $total_dirs))
    printf "\rProgress: %d%%" $percentage
done

echo -e "\nUpdate complete."
