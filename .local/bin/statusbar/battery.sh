_status=$(cat /sys/class/power_supply/BAT0/status)
charge_now=$(cat /sys/class/power_supply/BAT0/charge_now)
# charge_full=$(cat /sys/class/power_supply/BAT0/charge_full)
charge_full_design=$(cat /sys/class/power_supply/BAT0/charge_full_design)
# state=$(awk "BEGIN {printf \"%.2f\", ${charge_now} * 100 / ${charge_full_design}}")
state=$(echo "scale=2; $charge_now * 100 / $charge_full_design " | bc)
printf "%s:%s%s%% " "$_status" "$state"
