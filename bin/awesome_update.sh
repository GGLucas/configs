#!/bin/bash
### CPU
i=$1
p=$2
x=$3

CPUSTAT="$HOME/.cpustat"
old_cpu_vals=(`head -1 "$CPUSTAT"`)
cpu_old_user=${old_cpu_vals[0]}
cpu_old_nice=${old_cpu_vals[1]}
cpu_old_system=${old_cpu_vals[2]}
cpu_old_idle=${old_cpu_vals[3]}
cpu_old_total=`echo "$cpu_old_user + $cpu_old_nice + $cpu_old_system + $cpu_old_idle" | bc`

cpu_vals_text=`cat /proc/stat  | head -1 | sed -e 's/^cpu[^0-9]*//g' -e 's/\([^ ]\+ [^ ]\+ [^ ]\+ [^ ]\+\).*/\1/g'`
cpu_vals=($cpu_vals_text)
cpu_user=${cpu_vals[0]}
cpu_nice=${cpu_vals[1]}
cpu_system=${cpu_vals[2]}
cpu_idle=${cpu_vals[3]}
cpu_total=`echo "$cpu_user + $cpu_nice + $cpu_system + $cpu_idle" | bc`
pcpu=`echo "(100 * ($cpu_system - $cpu_old_system + $cpu_user - $cpu_old_user)) / ($cpu_total - $cpu_old_total)" | bc`
echo $cpu_vals_text > "$CPUSTAT"

### MEMORY
mem_vals=`free -m | grep '^Mem:' | sed 's/Mem://g'`
mtot=`echo $mem_vals | sed 's/ .*//g'`
muse=`echo $(echo $mem_vals | cut -f2,5,6 -d" " | sed 's/ / - /g') | bc`
pmem=`echo "100 * $muse / $mtot" | bc`


if [ $pcpu -lt 10 ]
then
    pcpu="0$pcpu"
fi

if [ $pmem -lt 10 ]
then
    pmem="0$pmem"
fi

if [ "$muse" -lt 1000 ]
then
    muse="0$muse"
fi

# Awesome 3
echo 0 widget_tell mystatusbar gp_mem data memdata "$pmem" | awesome-client
echo 1 widget_tell mystatusbar gp_mem data memdata "$pmem" | awesome-client
echo 0 widget_tell mystatusbar tx_mem text "$pmem% ($muse/$mtot) " | awesome-client
echo 1 widget_tell mystatusbar tx_mem text "$pmem% ($muse/$mtot) " | awesome-client

echo 0 widget_tell mystatusbar gp_cpu data cpudata "$pcpu" | awesome-client
echo 1 widget_tell mystatusbar gp_cpu data cpudata "$pcpu" | awesome-client

echo 0 widget_tell mystatusbar tx_cpu text "$pcpu% " | awesome-client
echo 1 widget_tell mystatusbar tx_cpu text "$pcpu% " | awesome-client

temp=`mpc | head -1 | sed "s/AnimeNfo Radio  | Serving you the best Anime music!: //"`
echo 0 widget_tell mystatusbar tx_mpd text "$temp" | awesome-client
echo 1 widget_tell mystatusbar tx_mpd text "$temp" | awesome-client

if [ "$i" -gt 30 ]
then
temp=`nvidia-settings -q [gpu:0]/GPUCoreTemp | grep '):' | awk '{print $4}' | sed 's/\.//'`
echo 0 widget_tell mystatusbar tx_gpu text "$temp" | awesome-client
echo 1 widget_tell mystatusbar tx_gpu text "$temp" | awesome-client
fi

if [ "$p" -gt 120 ]
then
bash /home/archlucas/other/.awggw.sh
fi
