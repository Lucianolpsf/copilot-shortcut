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
            WINDOW_TYPE=$(xprop -id "$ID" | grep "_NET_WM_WINDOW_TYPE" | awk '{print $3}')

            if [[ "$WINDOW_TYPE" == "_NET_WM_WINDOW_TYPE_NORMAL" ]]; then
                    WINDOW_ID="$ID"
                    break
            fi
        fi
    done

    if [ -z "$WINDOW_ID" ]; then
        echo "Window not found to '$APP_NAME'."
        exit 1
    fi

    WINDOW_NAME=$NAME
    WINDOW_CODE=$WINDOW_ID
fi

PRIMARY_MONITOR=$(xrandr --query | grep " primary" | awk '{print $1}')
MONITOR_GEOMETRY=$(xrandr --query | grep "^$PRIMARY_MONITOR" | awk '{print $4}')
MONITOR_X=$(echo $MONITOR_GEOMETRY | cut -d'+' -f2)
MONITOR_Y=$(echo $MONITOR_GEOMETRY | cut -d'+' -f3)
MONITOR_WIDTH=$(echo $MONITOR_GEOMETRY | cut -d'x' -f1)
MONITOR_HEIGHT=$(echo $MONITOR_GEOMETRY | cut -d'x' -f2 | cut -d'+' -f1)

NEW_WIDTH=700
NEW_HEIGHT=800

if [ $MONITOR_HEIGHT -lt $NEW_HEIGHT || $MONITOR_HEIGHT -lt 901 ]; then
    NEW_HEIGHT=600
fi

WORKAREA=$(xprop -root _NET_WORKAREA | awk -F' = ' '{print $2}' | tr -d ' ')
WORKAREA_X=$(echo $WORKAREA | cut -d',' -f1)
WORKAREA_Y=$(echo $WORKAREA | cut -d',' -f2)
WORKAREA_WIDTH=$(echo $WORKAREA | cut -d',' -f3)
WORKAREA_HEIGHT=$(echo $WORKAREA | cut -d',' -f4)

DOCK_HEIGHT=$(( $MONITOR_HEIGHT - $WORKAREA_HEIGHT ))

NEW_X=$(( $MONITOR_X + ( $MONITOR_WIDTH - $NEW_WIDTH) / 2 ))
NEW_Y=$(( $MONITOR_Y + $MONITOR_HEIGHT - $NEW_HEIGHT - $DOCK_HEIGHT + 22))

xdotool windowsize "$WINDOW_CODE" $NEW_WIDTH $NEW_HEIGHT
xdotool windowmove "$WINDOW_CODE" $NEW_X $NEW_Y

echo "Window Name: $WINDOW_NAME"
echo "Window Code: $WINDOW_CODE"
if wmctrl -l | grep -i "$WINDOW_NAME" > /dev/null 2>&1; then
    xdotool windowunmap $WINDOW_CODE
else
    xdotool windowmove $WINDOW_CODE $NEW_X $NEW_Y
    xdotool windowmap $WINDOW_CODE
    xdotool windowactivate $WINDOW_CODE
fi