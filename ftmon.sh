#!/bin/bash

SLEEP=1
FILE=ftmon_$(date +%Y%m%d%H%M).csv

#exec >> $FILE
exec &> >(tee -a "$FILE")
echo "Logged in $FILE"

echo "epoch [s], CPU usage [%], Clock [MHz], Tdie [C], Tgpu_edge [C], Tgpu_junc [C], Tsys [C], Power [W]"

EPOCH_PREV=$(date +%s.%N)
ENER_PREV=$(sensors -j 2>/dev/null | jq '."amd_energy-isa-0000".Esocket0.energy33_input')

read T0 U0 I0 <<<  $(grep 'cpu ' /proc/stat | awk '{print $2+$3+$4+$6+$7+$8+$9+$10+$11+$5, $2+$3+$4+$6+$7+$8+$9+$10+$11, $5}')

sleep $SLEEP

while true ; do

EPOCH_NOW=$(date +%s.%N)
ENER_NOW=$(sensors -j  2>/dev/null | jq '."amd_energy-isa-0000".Esocket0.energy33_input')

CLK=$(egrep "MHz" /proc/cpuinfo |cut -f 3 -d " " |jq -s add/length)
SENSORS=$(sensors -j  2>/dev/null | jq '."k10temp-pci-00c3".Tdie.temp2_input, ."amdgpu-pci-2300".edge.temp1_input, ."amdgpu-pci-2300".junction.temp2_input, ."max1617-i2c-0-4d".temp1.temp1_input'|tr '\n' ',')

read T1 U1 I1 <<<  $(grep 'cpu ' /proc/stat | awk '{print $2+$3+$4+$6+$7+$8+$9+$10+$11+$5, $2+$3+$4+$6+$7+$8+$9+$10+$11, $5}')

#IDLE=$(echo "scale=3; ($I1 - $I0) / ($T1 - $T0) * 100 "|bc)
CPU=$(echo "scale=3; ($U1 - $U0) / ($T1 - $T0) * 100 "|bc)
POW=$(echo "scale=3; ($ENER_NOW - $ENER_PREV) / ($EPOCH_NOW - $EPOCH_PREV)"|bc)

echo $EPOCH_NOW","$CPU","$CLK","$SENSORS$POW  

read T0 U0 I0 <<<  $(echo $T1 $U1 $I1)
EPOCH_PREV=$EPOCH_NOW
ENER_PREV=$ENER_NOW
sleep $SLEEP
done

