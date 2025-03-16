# Copilot Shortcut

This repository contains a **shell script** that facilitates the quick opening and closing of the **Copilot Desktop** application (distributed as a Snap) through shortcuts on the **Linux Ubuntu 22.04** system.

## 🎯 Objective
Provide a simple solution to manage the startup and shutdown of **Copilot Desktop** with custom shortcuts, optimizing the user experience.

## 🚀 Features
- **Quickly open** Copilot Desktop.
- **Close** the application with a single command.
- **Prevents multiple instances** of the application.
- **Compatible with Ubuntu 22.04** and other Linux distributions based on GNOME.

## ⚙️ Prerequisites
Before using the script, make sure you have the necessary dependencies installed on your system. You can install them with the following command:

```bash
sudo apt update && sudo apt install -y pgrep wmctrl xdotool git
```

Additionally, ensure that **Copilot Desktop** is installed via Snap:

```bash
sudo snap install copilot-desktop
```

These packages are required for process management and window manipulation, ensuring the script functions correctly.

## 📥 Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/lucianolpsf/copilot-shortcut.git
   cd copilot-shortcut
   ```

2. **Grant execution permission to the script:**
   ```bash
   chmod +x copilot-shortcut.sh
   ```

3. **Set up a shortcut on your system:**
   - On **GNOME** (Ubuntu):
     1. Open `Settings` > `Keyboard` > `Shortcuts`.
     2. Click on **Add Custom Shortcut**.
     3. In the **Name** field, enter `Copilot Shortcut`.
     4. In the **Command** field, enter the path to the script:
        ```
        /path/to/copilot-shortcut.sh
        ```
     5. Choose a key combination (e.g., `Ctrl + Alt + C`).
     6. Save and test the shortcut.

## 🛠️ Usage
- **To open Copilot Desktop**, press the configured shortcut.
- **To close the application**, press the same shortcut again (if the script includes this functionality).

## 🔧 Customization
If you want to modify the script's behavior, edit the `copilot-shortcut.sh` file and adjust the commands as needed.

## 📝 License
This project is licensed under the **MIT** license. Feel free to contribute and modify it as needed.

## 🤝 Contribution
Suggestions and improvements are welcome! Fork the repository, create a **pull request**, or open an **issue** to discuss new ideas.

---
📌 **Note:** The script was developed for Ubuntu 22.04 and may need adjustments for other versions or Linux distributions.

🚀 Enjoy the shortcuts and have a more efficient workflow with Copilot Desktop!

