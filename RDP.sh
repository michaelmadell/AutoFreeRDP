#!/bin/bash

#############################
#       CONFIGURATION       #
#                           #
#    !!SECURITY WARNING!!   #
#  PLAIN TEXT PASSWORDS ARE #
#     OBVIOUSLY INSECURE    #
# DO NOT USE IN PRODUCTION  #
#        ENVIRONMENT        #
#                           #
#############################

#-- CONNECTION CONFIG --#
readonly LOGFILE="/home/$USER/Desktop/RDPLOG.log"
readonly USERNAME="Admin"
readonly PASSWORD="Pass"
readonly DURATION_MINUTES=5

readonly DURATION_SECONDS=$(($DURATION_MINUTES*60))

#-- TARGET HOSTS --#
readonly HOSTS=(
    "10.50.0.1"
    "10.50.0.2"
)

#-- CONNECTION AND LOGGING FOR SINGLE HOST --#
connect_and_log() {
    local host="$1"
    local timestamp
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')

    duration_seconds = $DURATION * 60

    echo "[$timestamp] [INFO] Attempting connection to $host..." >> "$LOGFILE"

    ## Use 'timeout' to enforce a connection duration.
    ## We redirect stderr (2) to stdout (1) using 2>&1 to capture all output.
    ## Common flags added:
    ##  - /cert:ignore - Auto-Accepts certificates
    ##  - +auto-reconnect /auto-reconnect-max-retries:0 - prevents freerdp's own retry logic from interfering.
    local output
    output=$(timeout $($duration_seconds)s xfreerdp \
        /v:"$host" \
        /u:"$USERNAME" \
        /p:"$PASSWORD" \
        /cert:ignore \
        +auto-reconnect /auto-reconnect-max-retries:0 \
        2>&1)

    local exit_code=$?
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')

    # Interpret Exit Code
    if [ $exit_code -eq 124 ]; then
        echo "[$timestamp] [SUCCESS] Connection to $host closed after $DURATION Minutes." >> "$LOGFILE"
    elif [ $exit_code -eq 0 ]; then
        echo "[$timestamp] [INFO] Connection to $host closed successfully before timeout." >> "$LOGFILE"
    else
        echo "[$timestamp] [ERROR] Connection to $host failed. Exit Code: $exit_code" >> "$LOGFILE"
        echo "[$timestamp] [ERROR-DETAIL] $host: $output" >> "$LOGFILE"
    fi
}

#-- MAIN SCRIPT EXECUTION --#
#
#  Loops through all hosts  #
#  and launches connections #
#  for each as a background #
#  process using '&'        #
#                           #
#############################
for host in "${HOSTS[@]}"; do
    connect_and_log "$host" &
done

wait
