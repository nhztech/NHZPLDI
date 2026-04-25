#colors
source "$HOME/PROGRAMS/NHZPLDI/etc/lib/Typewriter.sh"
#Installing requirements

Typewriter -cy -cn "Installing Requirements"
sleep 0.5

Typewriter -cb -cn "Updating Repository"
sleep 0.2
Typewriter -s -cn "apt update" 0.02
sleep 0.5

Typewriter -cb -cn "Installing Proot-Distro"
sleep 0.2
Typewriter -s -cn "apt install proot-distro" 0.02
sleep 0.2

sleep 0.5
Typewriter -cb -cn "Installing Pulse-audio"
sleep 0.2
Typewriter -s -cn "apt install pulseaudio" 0.02
sleep 0.2


