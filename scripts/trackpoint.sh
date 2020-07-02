sudo sh -c "echo 5   > /sys/devices/platform/i8042/serio1/serio2/drift_time"       # default 5 
sudo sh -c "echo 200 > /sys/devices/platform/i8042/serio1/serio2/sensitivity"     # default 128
sudo sh -c "echo 120 > /sys/devices/platform/i8042/serio1/serio2/speed"           # default 97
