# Define variables
INSTALL_DIR=/opt/copilot
SHORTCUT_SCRIPT=copilot-shortcut.sh
SHORTCUT_PATH=$(INSTALL_DIR)/$(SHORTCUT_SCRIPT)

# Install dependencies
install_dependencies:
	sudo chmod 777 install-dependencies.sh
	clear
	bash ./install-dependencies.sh

# Move the shortcut script to /opt
install_shortcut:
	sudo mkdir -p $(INSTALL_DIR)
	sudo chmod 777 $(SHORTCUT_SCRIPT)
	sudo cp $(SHORTCUT_SCRIPT) $(INSTALL_DIR)/

# Configure a custom keyboard shortcut (Alt+Space) to run the script
create_shortcut:
	sudo chmod 777 add-shortcut.sh
	clear
	bash ./add-shortcut.sh

# Default target
install: install_dependencies install_shortcut create_shortcut

# Uninstall the script and remove the custom keyboard shortcut
uninstall:
	sudo rm -rf $(INSTALL_DIR)
	sudo chmod 777 remove-shortcut.sh
	clear
	bash ./remove-shortcut.sh