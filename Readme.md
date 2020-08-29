
1. Normal Noctua FAN x 2 ftmon_202008271818.csv
root@tr3970x:~/BenchMark# nice -n 10 stress --cpu 62 --io 4 --vm 32 --vm-bytes 1280M --timeout 600s
stress: info: [16806] dispatching hogs: 62 cpu, 4 io, 32 vm, 0 hdd
stress: info: [16806] successful run completed in 600s

2. CPU 32(64) -> 16(32) ftmon_202008271855.csv
597  for i in `seq 16 31` `seq 48 63` ; do echo -n "$i: " ; echo 0 > /sys/devices/system/cpu/cpu$i/online ; done
598  for i in `seq 16 31` `seq 48 63` ; do echo -n "$i: " ; cat /sys/devices/system/cpu/cpu$i/online ; done
 
root@tr3970x:~/BenchMark# nice -n 10 stress --cpu 62 --io 4 --vm 32 --vm-bytes 1280M --timeout 600s
stress: info: [38631] dispatching hogs: 62 cpu, 4 io, 32 vm, 0 hdd
stress: info: [38631] successful run completed in 601s

3. CPU FAN 2 -> 1 ftmon_202008271956.csv
root@tr3970x:~/BenchMark# nice -n 10 stress --cpu 62 --io 4 --vm 32 --vm-bytes 1280M --timeout 600s
stress: info: [5232] dispatching hogs: 62 cpu, 4 io, 32 vm, 0 hdd
stress: info: [5232] successful run completed in 601s



