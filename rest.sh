#!/bin/bash

# Replace 'your_command_here' with the command you want to run
COMMAND="xmrig -o pool.supportxmr.com:443 -u 8AWYSJJh3GTNVD34exWFKBeDdvhFtFFahdL6okLmuFTkFbYiAs6JtXCWQZw4r4Y7rNcT2jB2aKrb26pjLYsuE6obLnULufm -k --tls -p mini"

while true; do
    # Run the command in the background
    $COMMAND &

    # Get the PID of the last background command
    CMD_PID=$!

    # Wait for 3600 seconds (60 minutes)
    sleep 3600

    # Kill the command
    kill $CMD_PID

    # Wait for 120 seconds (2 minutes)
    sleep 120
done
