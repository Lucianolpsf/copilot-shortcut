#!/bin/bash

APP_NAME="copilot-desktop"
WINDOW_NAME_PREFIX="Microsoft Copilot:"
WINDOW_NAME=""
WINDOW_CODE=""
PID=$(pgrep -x "$APP_NAME")


if ! pgrep -x "$APP_NAME" > /dev/null || pgrep -x "$WINDOW_NAME" > /dev/null; then
    copilot-desktop &
    exit 1
else
    WINDOW_IDS=$(xdotool search --pid "$PID")

    for ID in $WINDOW_IDS; do
        NAME=$(xdotool getwindowname "$ID" 2>/dev/null)
        
        if [[ "$NAME" == "$WINDOW_NAME_PREFIX"* ]]; then
            WINDOW_ID="$ID"
            break  
        fi
    done

    if [ -z "$WINDOW_ID" ]; then
        echo "Window not found to '$APP_NAME'."
        exit 1
    fi

    WINDOW_NAME=$NAME

    WINDOW_CODE=$(xdotool search --name "$WINDOW_NAME")
fi


if wmctrl -l | grep -i "$WINDOW_NAME" > /dev/null 2>&1; then
    xdotool windowunmap $WINDOW_CODE
else
    xdotool windowmap $WINDOW_CODE
fi

