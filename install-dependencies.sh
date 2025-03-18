if ! command -v wmctrl &>/dev/null || ! command -v xdotool &>/dev/null; then
    sudo apt update
	sudo apt install -y wmctrl xdotool 
fi