#!/bin/bash

LAST_API_TIME=""
LAST_API_DATE=""
API_STATUS="OFFLINE"

HTTP_STATUS="ONLINE"
HTTP_LATENCY="-"

check_internet() {
    START=$(date +%s%3N)

    if curl -s --max-time 3 https://clients3.google.com/generate_204 >/dev/null; then
        END=$(date +%s%3N)
        HTTP_STATUS="ONLINE"
        HTTP_LATENCY="$((END-START))ms"
    else
        HTTP_STATUS="OFFLINE"
        HTTP_LATENCY="-"
    fi
}

sync_time() {
    RESP=$(curl -s --max-time 5 "https://timeapi.io/api/Time/current/zone?timeZone=UTC")

    if echo "$RESP" | grep -q "dateTime"; then
        DATETIME=$(echo "$RESP" | grep -o '"dateTime":"[^"]*' | cut -d'"' -f4)

        LAST_API_DATE=$(echo "$DATETIME" | cut -d'T' -f1)
        LAST_API_TIME=$(echo "$DATETIME" | cut -d'T' -f2)

        API_STATUS="ONLINE"
    else
        API_STATUS="OFFLINE"
    fi
}

broadcast() {
    while true
    do
        check_internet
        sync_time

        LOCAL_TIME=$(date +"%H:%M:%S")
        LOCAL_DATE=$(date +"%d/%m/%Y")

        echo "{\"local_time\":\"$LOCAL_TIME\",\"local_date\":\"$LOCAL_DATE\",\"api_time\":\"$LAST_API_TIME\",\"api_date\":\"$LAST_API_DATE\",\"api_status\":\"$API_STATUS\",\"http_status\":\"$HTTP_STATUS\",\"http_latency\":\"$HTTP_LATENCY\"}"

        sleep 1
    done
}

broadcast | websocat --text -s 0.0.0.0:9001 &

nginx -g "daemon off;"
