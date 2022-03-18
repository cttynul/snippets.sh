#!\bin\bash

reboot_target () {
  read -p "Press any key to reboot" par
  reboot now
}

echo "    __             __                             __ "
echo ".--|  .-----.-----|  |--.-----.--.--.______.-----|__|"
echo "|  _  |  _  |__ --|  _  |  _  |_   _|______|  _  |  |"
echo "|_____|_____|_____|_____|_____|__.__|      |   __|__|"
echo " -cttynul                                  |__|      "

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

read -p "Are you currently running this on a Raspberry PI? [Y|n]" rpi_op

if [ "$rpi_op" -eq "Y" ]
  then 
    echo To autologin perform following steps
    echo "> raspi-config"
    echo Choose option: 1 System Options
    echo Choose option: S5 Boot / Auto Login
    echo Choose option: B2 Console Autologin
    echo Select Finish, and reboot the Raspberry Pi.
fi

read -p "Do you want to turn your device into a Dosbox Machine? [Y|n]" option

if [ "$option" -ne "Y" ]
  then echo "Exiting..."
  exit
else
  apt update
  # Installing DOSBox
  apt -y install dosbox
  mkdir -p ~/DOS/C
  mkdir -p ~/DOS/A
  
  # DOSBox Conf Setup
  echo [sdl] >> `ls ~/.dosbox/dosbox-*.conf`
  echo fullscreen=true >> `ls ~/.dosbox/dosbox-*.conf`
  echo fullresolution=desktop >> `ls ~/.dosbox/dosbox-*.conf`
  echo usescancodes=false >> `ls ~/.dosbox/dosbox-*.conf`
  echo [render]
  echo aspect=true >> `ls ~/.dosbox/dosbox-*.conf`
  echo [autoexec] >> `ls ~/.dosbox/dosbox-*.conf` 
  echo MOUNT A ~/DOS/A >> `ls ~/.dosbox/dosbox-*.conf`
  echo MOUNT C ~/DOS/C >> `ls ~/.dosbox/dosbox-*.conf`
  echo C: >> `ls ~/.dosbox/dosbox-*.conf`
  echo DIR C:\ >> `ls ~/.dosbox/dosbox-*.conf`
  
  # Setting up samba share for C and A DOSbox Drives
  apt install -y samba samba-common-bin
  chmod 777 ~/DOS/C
  chmod 777 ~/DOS/A
  echo [DOSBox] >> /etc/samba/smb.conf
  echo path=~/DOS/ >> /etc/samba/smb.conf
  echo writeable=yes  >> /etc/samba/smb.conf
  echo create mask=0777 >> /etc/samba/smb.conf
  echo directory mask=0777 >> /etc/samba/smb.conf
  echo public=yes >> /etc/samba/smb.conf
  echo read only=no >> /etc/samba/smb.conf
  systemctl enable smbd
  systemctl restart smbd
  echo "You can access your DOS drive from another PC in your LAN browsing:"
  echo smb://$(hostname) or smb://$(hostname -I)
  echo "Enjoy"
  echo "- cttynul"
fi

# RPI Settings
if [ "$rpi_op" -eq "Y" ]
  then 
    #forcing 640x480 pi resolution
    echo hdmi_group=1 >> /boot/config.txt
    echo hdmi_mode=1 >> /boot/config.txt
fi

read -p "Do you want to install RetroPie? [Y|n]" option
if [ "$option" -ne "Y" ]
  then reboot_target
else
  apt install -y git
  apt install -y libsdl*dev
  git clone https://github.com/RetroPie/RetroPie-Setup.git
  chmod +x ./RetroPie-Setup/retropie_setup.sh
  ./RetroPie-Setup/retropie_setup.sh
  chmod 777 ~/RetroPie
  echo [RetroPie] >> /etc/samba/smb.conf
  echo path=~/RetroPie >> /etc/samba/smb.conf
  echo writeable=yes  >> /etc/samba/smb.conf
  echo create mask=0777 >> /etc/samba/smb.conf
  echo directory mask=0777 >> /etc/samba/smb.conf
  echo public=yes >> /etc/samba/smb.conf
  echo read only=no >> /etc/samba/smb.conf
  systemctl restart smbd
  echo "You can access your RetroPie folder from another PC in your LAN browsing:"
  echo smb://$(hostname) or smb://$(hostname -I)
  echo "To run Retropie you need to type emulationstation in your Rasbian CLI"
  echo "- cttynul"
  reboot_target
fi
