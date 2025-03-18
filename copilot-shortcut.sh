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

SCREEN_WIDTH=$(xdpyinfo | awk '/dimensions/{print $2}' | cut -d 'x' -f1)
SCREEN_HEIGHT=$(xdpyinfo | awk '/dimensions/{print $2}' | cut -d 'x' -f2)

DOCK_HEIGHT=$(xprop "-root" _NET_WORKAREA | awk '{print $4}' | sed 's/,//g')
WORKAREA_HEIGHT=$(( $SCREEN_HEIGHT - $DOCK_HEIGHT ))

WINDOW_GEOMETRY=$(xdotool getwindowgeometry --shell "$WINDOW_CODE")
# WINDOW_WIDTH=$(echo "$WINDOW_GEOMETRY" | grep WIDTH | cut -d '=' -f2)
# WINDOW_HEIGHT=$(echo "$WINDOW_GEOMETRY" | grep HEIGHT | cut -d '=' -f2)

NEW_WIDTH=800
NEW_HEIGHT=600
xdotool windowsize "$WINDOW_CODE" $NEW_WIDTH $NEW_HEIGHT

NEW_X=$(( ($SCREEN_WIDTH - $NEW_WIDTH) / 2 ))
NEW_Y=$(( $SCREEN_HEIGHT - $NEW_HEIGHT - $DOCK_HEIGHT - 20))


if wmctrl -l | grep -i "$WINDOW_NAME" > /dev/null 2>&1; then
    xdotool windowunmap $WINDOW_CODE
else
    xdotool windowmove $WINDOW_CODE $NEW_X $NEW_Y
    xdotool windowmap $WINDOW_CODE
fi

