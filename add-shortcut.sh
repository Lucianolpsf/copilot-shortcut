#!/bin/bash

SHORTCUT_NAME="Copilot"
SHORTCUT_COMMAND="/opt/copilot/copilot-shortcut.sh"
NEW_BINDING="<Alt>space"

KEY_PATH=$(gsettings get org.gnome.settings-daemon.plugins.media-keys custom-keybindings)

# Remove unnecessary characters (e.g., ['@as []'])
KEY_PATH=$(echo "$KEY_PATH" | sed 's/^\[//;s/\]$//;s/@as//;s/ //g')

# Split the KEY_PATH into an array
IFS=',' read -r -a CAMINHOS <<< "$KEY_PATH"


for CAMINHO in "${CAMINHOS[@]}"; do

    CAMINHO=$(echo "$CAMINHO" | xargs)

    # Ensure the path starts with a slash
    if [[ ! "$CAMINHO" =~ ^/ ]]; then
        CAMINHO="/$CAMINHO"
    fi
    
    CAMINHO_NAME="${CAMINHO}/name"
    
    CAMINHO_NAME=$(echo "$CAMINHO_NAME" | sed 's|//|/|g')

    CAMINHO_NAME=$(echo "$CAMINHO_NAME" | sed 's/,//g')

    NOME_ATUAL=$(dconf read "$CAMINHO_NAME")
    
    if [[ "$NOME_ATUAL" == "'$SHORTCUT_NAME'" ]]; then
        echo "The shortcut  '$SHORTCUT_NAME' already exists."
        echo "Press Alt+space to activate the shortcut."
        exit 0
    fi
done


INDEX=0
while [[ " ${CAMINHOS[*]} " =~ " /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom$INDEX/ " ]]; do
    ((INDEX++))
done

NEW_PATH="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom$INDEX/"

if [[ -z "$KEY_PATH" ]]; then
    UPDATED_BINDINGS="'$NEW_PATH'"
else
    UPDATED_BINDINGS="[$KEY_PATH, $NEW_PATH]"
    
    if [[ $(echo "$UPDATE_BINDINGS" | grep -o ',' | wc -l) -eq 0 ]]; then
  
        UPDATED_BINDINGS="['$NEW_PATH']"
    fi
fi

gsettings set org.gnome.desktop.wm.keybindings activate-window-menu "[]"
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "$UPDATED_BINDINGS"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$NEW_PATH name "$SHORTCUT_NAME"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$NEW_PATH command "$SHORTCUT_COMMAND"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$NEW_PATH binding "$NEW_BINDING"

echo "The shortcut '$SHORTCUT_NAME' has been added successfully."
echo "Press  $NEW_BINDING to activate the shortcut."