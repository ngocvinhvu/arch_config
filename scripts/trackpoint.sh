sudo sh -c "echo 15  > /sys/devices/platform/i8042/serio1/serio2/drift_time"       # default 5 
sudo sh -c "echo 200 > /sys/devices/platform/i8042/serio1/serio2/sensitivity"     # default 128
sudo sh -c "echo 150 > /sys/devices/platform/i8042/serio1/serio2/speed"           # default 97
