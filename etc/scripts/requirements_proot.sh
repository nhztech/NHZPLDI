source "$HOME/PROGRAMS/NHZPLDI/etc/lib/lib_manager.sh"

load Typewriter as tw

tw -cy -cn "Installing Requirements"
sleep 0.5

tw -cb -cn "Updating Repository"
sleep 0.5

tw -s -cn "apt update" 0.02
sleep 0.5

tw -cn -cn "Installing Proot"
sleep 0.5

tw -s -cn "apt install proot" 0.02
sleep 0.2

sleep 0.5
tw -cb -cn "Installing Pulse-audio"
sleep 0.2

tw -s -cn "apt install pulseaudio" 0.02
sleep 0.2

sleep 0.5
tw -cb -cn "Installing Wget"
sleep 0.2

tw -s -cn "apt install wget" 0.02
sleep 0.2

sleep 0.5
tw -cb -cn "Installing Tar"
sleep 0.5

tw -s -cn "apt install tar" 0.02
sleep 0.2
