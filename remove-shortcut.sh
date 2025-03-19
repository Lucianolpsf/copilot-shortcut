# #!/bin/bash

TARGET_BINDING="'<Alt>space>'"
TARGET_NAME="'Copilot'"

KEY_PATH=$(gsettings get org.gnome.settings-daemon.plugins.media-keys custom-keybindings)

# Remove unnecessary characters (e.g., ['@as []'])
KEY_PATH=$(echo "$KEY_PATH" | sed 's/^\[//;s/\]$//;s/@as//;s/ //g')

# Split the KEY_PATH into an array
IFS=',' read -r -a CAMINHOS <<< "$KEY_PATH"

NEW_CAMINHOS=()

for CAMINHO in "${CAMINHOS[@]}"; do

    CAMINHO=$(echo "$CAMINHO" | xargs)
    
    CAMINHO_BINDING="${CAMINHO} binding"

    CAMINHO_BINDING=$(echo "$CAMINHO_BINDING" | sed 's|//|/|g') 

    BINDING=$(gsettings get org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$CAMINHO_BINDING)
    SHORTCUT_NAME=$(gsettings get org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:${CAMINHO} name)
    

    if [[ "$BINDING" == "'<Alt>space'" && "$SHORTCUT_NAME" == "'Copilot'" ]]; then
        echo -e "\n🔧 \e[1mRemoving the action shortcut $SHORTCUT_NAME ($BINDING)...\e[0m\n"
    else
        NEW_CAMINHOS+=("'$CAMINHO'")
    fi

done

NEW_LIST="[$(IFS=,; echo "${NEW_CAMINHOS[*]}")]"

gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "$NEW_LIST"
gsettings reset org.gnome.desktop.wm.keybindings activate-window-menu


echo -e "✅ \e[1mAll related files have been removed.\e[0m"
echo -e "✅ \e[1mShortcut successfully removed!\e[0m\n"
echo -e "If you want to remove \e[1mCopilot Desktop (Snap)\e[0m, run:\n"
echo -e "\e[1;32msnap remove copilot-desktop\e[0m\n"

