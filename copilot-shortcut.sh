#!/bin/bash

APP_NAME="copilot-desktop"
WINDOW_NAME="Microsoft Copilot: seu companheiro de IA"
WINDOW_CODE=""

# Verifica se o aplicativo está rodando
if ! pgrep -x "$APP_NAME" > /dev/null || pgrep -x "$WINDOW_NAME" > /dev/null; then
    copilot-desktop &
    exit 1
else
    WINDOW_CODE=$(xdotool search --name "$WINDOW_NAME")
fi


# Verifica se a janela do Copilot está aberta no X11
if wmctrl -l | grep -i "$WINDOW_NAME" > /dev/null 2>&1; then
    # wmctrl -a "$WINDOW_NAME" &
    xdotool windowunmap $WINDOW_CODE
else
    xdotool windowmap $WINDOW_CODE
fi

