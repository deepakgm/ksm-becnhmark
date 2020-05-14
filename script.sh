#!/bin/bash

# change run time here
RUN_TIME_IN_SECONDS=720

for i in $(seq 1 $RUN_TIME_IN_SECONDS)
  do
    run=$(cat /sys/kernel/mm/ksm/run)
    pages_shared=$(cat /sys/kernel/mm/ksm/pages_shared)
    pages_to_scan=$(cat /sys/kernel/mm/ksm/pages_to_scan)
    pages_unshared=$(cat /sys/kernel/mm/ksm/pages_unshared)
    pages_volatile=$(cat /sys/kernel/mm/ksm/pages_volatile)
    full_scans=$(cat /sys/kernel/mm/ksm/full_scans)

    CPU_USAGE=$(top -b -n2 -p 1 | fgrep "Cpu(s)" | tail -1 | awk -F'id,' -v prefix="$prefix" '{ split($1, vs, ","); v=vs[length(vs)]; sub("%", "", v); printf "%s%.1f%%\n", prefix, 100 - v }')
    FREE_DATA=$(free -m | grep Mem)
    CURRENT=$(echo $FREE_DATA | cut -f3 -d' ')
    TOTAL=$(echo $FREE_DATA | cut -f2 -d' ')
    RAM=$(echo "scale = 2; $CURRENT/$TOTAL*100" | bc)

    EPOCH=$(date +%s)
    echo "$i,$run,$pages_shared,$pages_to_scan,$pages_unshared,$pages_volatile,$full_scans,$CPU_USAGE,$CURRENT,$TOTAL,$RAM,$EPOCH" >> metrics.csv
    sleep 5
done
