#!/bin/bash

# ANSI colors
GREEN="\e[32m"
RESET="\e[0m"

# Find the Solr process (filter out grep)
PROC=$(ps aux | grep solr | grep start.jar | grep -v grep)

if [ -z "$PROC" ]; then
    echo "DOWN"
    exit 0
fi

# Print UP in green
echo -e "${GREEN}UP${RESET}"

# Parse ps aux fields
USER=$(echo "$PROC" | awk '{print $1}')
PID=$(echo "$PROC" | awk '{print $2}')
CPU=$(echo "$PROC" | awk '{print $3}')
RAM=$(echo "$PROC" | awk '{print $4}')
VIRT=$(echo "$PROC" | awk '{print $5}')
RES=$(echo "$PROC" | awk '{print $6}')
STATE=$(echo "$PROC" | awk '{print $8}')
START=$(echo "$PROC" | awk '{print $9}')
CPU_TIME=$(echo "$PROC" | awk '{print $10}')

# Command (everything from field 11 onward)
CMD=$(echo "$PROC" | cut -d' ' -f11-)

echo -e "${USER}\tuser running the process"
echo -e "${PID}\tprocess ID (PID)"
echo -e "${CPU}\tCPU usage (%)"
echo -e "${RAM}\tRAM usage (%)"
echo -e "${VIRT}\tvirtual memory"
echo -e "${RES}\tresident memory (RSS)"
echo -e "${STATE}\tprocess state"
echo -e "${START}\tstart time"
echo -e "${CPU_TIME}\tCPU time consumed"
