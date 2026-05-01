#!/bin/bash

# Color
White="$(printf '\033[1;37m')"
Red="$(printf '\033[1;31m')"
Blue="$(printf '\033[38;2;0;180;255m')"
Green="$(printf '\033[38;2;50;205;50m')"
Yellow="$(printf '\033[38;2;245;185;63m')"
Orange="$(printf '\033[1;38;2;244;117;27m')"
Reset="$(printf '\033[0m')"

# Word Formatting
Bold="$(printf '\033[1m')"

# Sources
source "$HOME/NHZPLDI/etc/lib/Typewriter.sh"
source "$HOME/NHZPLDI/etc/lib/align_text.sh"
source "$HOME/NHZPLDI/etc/config.txt"

ARCHITECTURE=$(dpkg --print-architecture)

# Banners
NHZPLDI_Banner_Static() {
    echo ${Green}"       _   __  __  __  _____      ____    __      ____    ______
      / | / / / / / / /__  /     / __ \  / /     / __ \  /_   _/
     /  |/ / / /_/ /    / /     / /_/ / / /     / / / /   / /
    / /|  / / __  /    / /___  / ____/ / /___  / /_/ / _ / /_
   /_/ |_/ /_/ /_/    /_____/ /_/     /____ / /_____/ /_____/
    "
    echo "${Blue}             (NHZ-PROOT-LINUX-DISTRO-INSTALLER)"
    echo "${White}               Author: Nick Codings/NHZTech"
    echo ""
    sleep 1
}

NHZPLDI_Banner_Dynamic() {
    local LOGO=$(cat << "EOF"
       _   __  __  __  _____      ____    __      ____    ______
      / | / / / / / / /__  /     / __ \  / /     / __ \  /_   _/
     /  |/ / / /_/ /    / /     / /_/ / / /     / / / /   / /
    / /|  / / __  /    / /___  / ____/ / /___  / /_/ / _ / /_
   /_/ |_/ /_/ /_/    /_____/ /_/     /____ / /_____/ /_____/

EOF
    )
    printf "${Green}"
    Typewriter "$LOGO" 0.001
    echo ""
    echo  "${Blue}            (NHZ-PROOT-LINUX-DISTRO-INSTALLER)"
    sleep 0.5
    echo "${White}               Author: Nick Codings/NHZTech"
    sleep 0.5
    printf "${Reset}\n"
}

custom_rootfs_link() {

    NHZPLDI_Banner_Static

    if [[ "$Requirements_PROOT_Installed" == "False" ]]; then
        bash $HOME/NHZPLDI/etc/scripts/requirements_proot.sh
        sed -i 's/^Requirements_PROOT_Installed=.*/Requirements_PROOT_Installed=True/' "$HOME/NHZPLDI/etc/config.txt"
    elif [[ "$Requirements_PROOT_Installed" == "True" ]]; then
        Typewriter -cy "Upgrading Packages!"
        sleep 0.5
        apt upgrade
    else
        Typewriter -cr "This Program is corrupted or Modified! Please re-install the program from original developer!"
        exit 1
    fi

    # Request Permission
    cd $HOME

    if [ ! -d "storage" ]; then
        echo ${G}"Please allow storage permissions"
        termux-setup-storage
        clear
    fi

    # Get Architecture
    case `dpkg --print-architecture` in
        aarch64)
            arch="arm64" ;;
        arm*)
            arch="armhf" ;;
        ppc64el)
            arch="ppc64el" ;;
        x86_64)
            arch="amd64" ;;
        *)
            echo "Unknown architecture"; exit 1 ;;
    esac

    sleep 1
    clear
    sleep 1.5

    # Print Architecture and Instuctions
    NHZPLDI_Banner_Static
    echo "Your CPU architecture is ${Green}[${Blue} $ARCHITECTURE/$arch ${Green}]" ${White}
    sleep 0.5
    echo ""
    echo "Please Find the ${Green}rootfs link${White} of the ${Green}Linux Distro${White} you want to install"${White}
    sleep 0.5
    echo ""
    echo "Example: ${Green}[ ${Blue}Ubuntu 23.10${Green} ] ${White} rootfs link: "
    echo ""
    echo -e "https://cloud-images.ubuntu.com/releases/23.10/release/ubuntu-23.10-server-cloudimg-arm64-root.tar.xz"
    echo ""
    sleep 0.5
    echo "Press ${Green}Enter${White} if done finding the ${Green}ROOTFS Link${White} to${Green} continue ${Red}" ${White}
    read enter
    sleep 2
    clear
    cd $HOME

    # Get Link
    NHZPLDI_Banner_Static

    printf "${Blue}Enter the ROOTFS link: ${Reset}"
    read LINK
    sleep 1
    echo ""
    echo "Please put your ${Green}distro name!"${Reset}
    echo ""
    echo "If you put ${Blue}'ubuntu'${White}, your ${Green}login script${White} will be ${Green}'bash ubuntu.sh' "${Reset}
    echo ""
    sleep 1

    #Get Distro Name
    printf "${Blue}Distro Name: ${Reset}"
    read dm
    sleep 1
    echo ""
    echo "Your ${Green}Distro Name${Reset} is ${Blue}$dm${Reset} and your login command is ${Green}'bash $dm.sh"${Reset}
    sleep 2 ; cd
    folder=$dm-fs

    # Folder Notice
    if [ -d "$folder" ]; then
        echo ""
        Typewriter -cr "Existing directory found, are you sure to remove it (y/n)? "${Green}
        read ans
        if [[ "$ans" =~ ^([yY])$ ]]; then
            echo ""
            Typewriter -cg -cn "Deleting existing directory...."
            rm -rf ~/$folder
            rm -rf ~/$dm.sh
            sleep 1
            if [ -d "$folder" ]; then
                Typewriter -cr "Cannot remove directory"; exit 1
            fi
        elif [[ "$ans" =~ ^([nN])$ ]]; then
            Typewriter -cr "Sorry, but we can't complete the installation"
            exit
        else
            echo ${Red}"Invalid answer"; exit 1
        fi
    else
        mkdir -p ~/$folder
    fi

    #Downloading and decompressing rootfs
    clear
    NHZPLDI_Banner_Static
    echo ${Blue}"Downloading $dm Root file system....."${White}
    wget -q --show-progress $LINK -P ~/$folder/
    if [ "$(ls ~/$folder)" == "" ]; then
        echo ${Red}"Error in downloading rootfs..."; exit 1
    fi
    echo ${Blue}"Decompressing Rootfs....."${White}
    proot --link2symlink \
        tar -xpf ~/$folder/*.tar.* -C ~/$folder/ --exclude='dev'
    if [[ ! -d "$folder/root" ]]; then
        mv $folder/*/* $folder/
        if [[ ! -d "$folder/root" ]]; then
            echo ${Red}"Error in decompressing rootfs"; exit 1
        fi
    fi

    #Setting up environment
    mkdir -p ~/$folder/tmp
    echo "127.0.0.1 localhost" > ~/$folder/etc/hosts
    rm -rf ~/$folder/etc/hostname
    rm -rf ~/$folder/etc/resolv.conf
    echo "localhost" > ~/$folder/etc/hostname
    echo "nameserver 8.8.8.8" > ~/$folder/etc/resolv.conf
    echo -e "#!/bin/sh\nexit" > ~/$folder/usr/bin/groups
    mkdir -p $folder/binds
cat <<- EOF >> "$folder/etc/environment"
EXTERNAL_STORAGE=/sdcard
LANG=en_US.UTF-8
MOZ_FAKE_NO_SANDBOX=1
PATH=/usr/local/sbin:/usr/local/bin:/bin:/usr/bin:/sbin:/usr/sbin:/usr/games:/usr/local/games
PULSE_SERVER=127.0.0.1
TERM=xterm-256color
TMPDIR=/tmp
EOF

    #Sound Fix
    echo "export PULSE_SERVER=127.0.0.1" >> $folder/root/.bashrc

    ##script
    echo
    Typewriter -cb "Writing launch script"
    sleep 1
    bin=$dm.sh
cat > $bin <<- EOM
#!/bin/bash
cd \$(dirname \$0)

## Start pulseaudio
pulseaudio --start --load="module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1" --exit-idle-time=-1

## Set login shell for different distributions
login_shell=\$(grep "^root:" "$folder/etc/passwd" | cut -d ':' -f 7)

## unset LD_PRELOAD in case termux-exec is installed
unset LD_PRELOAD

## Proot Command
command="proot"
## uncomment following line if you are having FATAL: kernel too old message.
#command+=" -k 4.14.81"
command+=" --link2symlink"
command+=" -0"
command+=" -r $folder"
if [ -n "\$(ls -A $folder/binds)" ]; then
    for f in $folder/binds/* ;do
      . \$f
    done
fi
command+=" -b /dev"
command+=" -b /dev/null:/proc/sys/kernel/cap_last_cap"
command+=" -b /proc"
command+=" -b /dev/null:/proc/stat"
command+=" -b /sys"
command+=" -b /data/data/com.termux/files/usr/tmp:/tmp"
command+=" -b $folder/tmp:/dev/shm"
command+=" -b /data/data/com.termux"
command+=" -b /sdcard"
command+=" -b /storage"
command+=" -b /mnt"
command+=" -w /root"
command+=" /usr/bin/env -i"
command+=" HOME=/root"
command+=" PATH=/usr/local/sbin:/usr/local/bin:/bin:/usr/bin:/sbin:/usr/sbin:/usr/games:/usr/local/games"
command+=" TERM=\$TERM"
command+=" LANG=C.UTF-8"
command+=" \$login_shell"
com="\$@"
if [ -z "\$1" ];then
    exec \$command
else
    \$command -c "\$com"
fi
EOM

    clear
    termux-fix-shebang $bin
    rm -rf $folder/*.tar.*
    bash $bin "touch ~/.hushlogin ; exit"
    clear

    #Banner
    NHZPLDI_Banner_Dynamic
    sleep 1
    Typewriter -cn "If you find ${Red}problem/errors${Reset} re-install and re-run the script."
    sleep 0.5
    Typewriter -cn "You can now start your distro with ${Blue}'$dm.sh'${Reset} script"
    sleep 0.5
    Typewriter -cn "${Green}Runner Command ${Reset}: ${Blue}bash $dm.sh "
    sleep 1
    Typewriter -cg "Running $dm....."
    echo
    bash $dm.sh
}

proot_distro() {
    NHZPLDI_Banner_Static

    if [[ "$Requirements_PD_Installed" == "False" ]]; then
        bash $HOME/NHZPLDI/etc/scripts/requirements_pd.sh
        sed -i 's/^Requirements_PD_Installed=.*/Requirements_PD_Installed=True/' "$HOME/NHZPLDI/etc/config.txt"
    elif [[ "$Requirements_PD_Installed" == "True" ]]; then
        Typewriter -cy "Upgrading Pacakges!"
        sleep 0.5
        apt upgrade
    else
        Typewriter -cr "This Program is corrupted or Modified! Please re-install the program from original developer!"
        exit 1
    fi

    clear

    NHZPLDI_Banner_Static
    echo ${Green}"Choose [${Blue} DISTRO ${Green}]:" ${Reset}
    echo ""
    declare -a DISTRO_NAMES
    declare -a DISTRO_ALIASES

    while IFS= read -r line; do
        clean_line=$(echo "$line" | sed -r "s/\x1B\[([0-9]{1,3}(;[0-9]{1,2})?)?[mGK]//g")

        name=$(echo "$clean_line" | awk -F'<' '{print $1}' | tr -d '*' | xargs)
        alias=$(echo "$clean_line" | grep -o '<.*>' | tr -d '<> ')

        if [ -n "$name" ] && [ -n "$alias" ]; then
            DISTRO_NAMES+=("$name")
            DISTRO_ALIASES+=("$alias")
        fi

    done < <(PROOT_NO_COLOR=1 proot-distro list 2>&1 | grep "[*]")

    total_distros=${#DISTRO_NAMES[@]}

    for (( x=0; x<total_distros; x++ )); do
        printf -v line_text "%-2s %s" "$((x+1))." "${DISTRO_NAMES[$x]}"
        Typewriter " $line_text" 0.001
    done

    echo ""
    read -p ${Blue}"Select:  ${Reset}" choice

    if ! [[ "$choice" =~ ^[0-9]+$ ]] || [ "$choice" -lt 1 ] || [ "$choice" -gt "$total_distros" ]; then
        echo "Invalid input! Please select a number from 1 to $total_distros."
        exit 1
    fi

    index=$((choice-1))
    SELECTED_NAME="${DISTRO_NAMES[$index]}"
    SELECTED_ALIAS="${DISTRO_ALIASES[$index]}"

    clear
    NHZPLDI_Banner_Static

    Typewriter -s "proot-distro install $SELECTED_ALIAS"
    proot-distro install "$SELECTED_ALIAS"

    clear

    NHZPLDI_Banner_Dynamic
    echo
    Typewriter "You can now start your distro with ${Blue}proot-distro login $SELECTED_ALIAS${Reset} use ${Blue}pd${Reset}as shortcut for ${Blue}proot-distro${Reset}"
    sleep 0.5
    Typewriter "${Green}Alternative Command :${Reset} ${Blue}pd login ${SELECTED_ALIAS} "
    echo ""
    Typewriter -s "proot-distro login $SELECTED_ALIAS"
    proot-distro login "$SELECTED_ALIAS"
}


glossary() {

    NHZPLDI_Banner_Static

    Typewriter -cb "${Bold}LIST OF TERMINOLOGIES${Reset}" 0.01

    terminologies="
 1. ${Bold}${Green}CUSTOM ROOTFS LINK INSTALLATION METHOD${Reset} -  is a method of installing a Linux Distribution where the user manually searches for a specific rootfs link in the Web for your desired distribution.

 2. ${Bold}${Green}PROOT-DISTRO METHOD${Reset} - is another method of installing a distribution OS in Termux which utilizes the 'proot-distro' software for a more automated installation.

 3. ${Bold}${Green}PROOT-DISTRO${Reset} - is a Bash script wrapper for utility proot for easy management of chroot-based Linux distribution installations. It does not require root or any special ROM, kernel, etc. Everything you need to get started is the latest version of Termux application. See Installing for details.
    ${Bold}${Blue}Sources:${Reset} (sylirre, 2026) - https://github.com/termux/proot-distro

 4. ${Bold}${Green}NHZPLDI${Reset} - is a powerful script that is develop by NHZTech/Nick Codingss that helps you install different Linux systems (Distros) on your Android phone using Termux. Instead of typing long and confusing commands, NHZPLDI does the hard work for you. It provides a clean menu where you can just pick a Linux version, and it will automatically download and set it up in seconds. It is designed to be fast and more user-friendly."

    formatted_terminologies=$(align_text "$terminologies")
    Typewriter "${formatted_terminologies}" 0.001

    echo ""
    Typewriter -cb "Wanna learn more? Follow Social Media platforms!"
    socials="
${Bold}${Red}YouTube${Reset}: Nick Codings | https://youtube.com/@nick-codings?si=yE9PhmqKCRbDJPgn${Reset}

${Bold}GitHub${Reset}: NHZTech | https://github.com/nhztech
"
   formatted_socials=$(align_text "$socials")
   Typewriter "${formatted_socials}"
   echo ""
   printf "\e[?25l"

   echo -n "Press any key to exit.. "

    while true; do
        printf "_"
        read -s -n 1 -t 0.5 key
        if [ $? -eq 0 ]; then
            break
        fi
        printf "\b \b"
        read -s -n 1 -t 0.5 key
        if [ $? -eq 0 ]; then
            break
        fi
    done
    printf "\e[?25h"

}



## Program Starts here

clear
NHZPLDI_Banner_Dynamic

# Disclaimer
Typewriter ${Green}"This script is made by [${Blue} NHZ/Nick-Codings ${Green}]" 0.01
echo""
sleep 0.5
Typewriter -n -cr "Warning! "
sleep 0.5
Typewriter -cr "Error may occur during installation!" 0.02
sleep 0.5
echo ""
echo ${Green}"Please try to re-run the script"${White}
sleep 2
clear
sleep 1

main_menu(){
    clear
    sleep 1

    NHZPLDI_Banner_Static

    method_list="${Green}Select [ ${Blue}Method${Green} ]:
${White}
 1. Custom rootfs link install
 2. Proot-distro
 3. Learn More
 4. Exit
"

    Typewriter "$method_list" 0.01

    sleep .5
    printf "${Blue}Select: ${Reset}"
    read user_input

    sleep 1

    if [[ "${user_input}" == "1" ]]; then
        clear
        sleep 1
        custom_rootfs_link

    elif [[ "${user_input}" == "2" ]]; then
        clear
        sleep 1
        proot_distro

    elif [[ "${user_input}" == "3" ]]; then
        clear
        sleep 1
        glossary
        main_menu

    elif [[ "${user_input}" == "4" ]]; then
        echo "Exiting..."
        printf "\e[?25h"
        exit 0

    else
        Typewriter -cr "Wrong option!!"
        sleep 1
        main_menu
    fi
}

main_menu
