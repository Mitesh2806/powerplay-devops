#!/bin/bash

# Configuration
LOG_GROUP="/devops/powerplay-server-metrics"
STREAM_NAME="powerplay-server-logs"
LOG_FILE="/var/log/system_report.log"

# 1. Generate Timestamp (Milliseconds required by AWS)
TIMESTAMP=$(date +%s000)

# 2. Capture the last 20 lines of the log file
# We use 'tr' to handle newlines safely for JSON
MESSAGE=$(tail -n 20 $LOG_FILE)

# 3. Push to CloudWatch
echo "Pushing logs to CloudWatch Group: $LOG_GROUP..."

aws logs put-log-events \
    --log-group-name "$LOG_GROUP" \
    --log-stream-name "$STREAM_NAME" \
    --log-events timestamp=$TIMESTAMP,message="$MESSAGE"

echo "Done."