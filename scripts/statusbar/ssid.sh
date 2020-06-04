#!/bin/sh
iw wlp3s0 info | awk '/ssid/ {print $2}'
