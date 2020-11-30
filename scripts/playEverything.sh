#!/bin/bash
aplay -D plughw:1,0  -f S32_LE -r 24000 "$*"
