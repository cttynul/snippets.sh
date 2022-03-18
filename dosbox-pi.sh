#!\bin\bash

reboot_target () {
  read -p "Press ENTER to reboot " par
  sudo reboot now
}

echo "    __             __                             __ "
echo ".--|  .-----.-----|  |--.-----.--.--.______.-----|__|"
echo "|  _  |  _  |__ --|  _  |  _  |_   _|______|  _  |  |"
echo "|_____|_____|_____|_____|_____|__.__|      |   __|__|"
echo " -cttynul                                  |__|      "
echo ""
read -p "Are you currently running this on a Raspberry PI? [Y|n] " rpi_op

if [ "$rpi_op" == "Y" ]
  then 
    echo To autologin perform following steps
    echo "> raspi-config"
    echo Choose option: 1 System Options
    echo Choose option: S5 Boot / Auto Login
    echo Choose option: B2 Console Autologin
    echo Select Finish, and reboot the Raspberry Pi.
fi

read -p "Do you want to turn your device into a Dosbox Machine? [Y|n] " option

if [ "$option" != "Y" ]
  then echo "Exiting..."
  exit
else
  sudo apt update
  # Installing DOSBox
  sudo apt -y install dosbox
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
  sudo apt install -y samba samba-common-bin
  sudo chmod 777 ~/DOS/C
  sudo chmod 777 ~/DOS/A
  sudo echo [DOSBox] >> /etc/samba/smb.conf
  sudo echo path=~/DOS/ >> /etc/samba/smb.conf
  sudo echo writeable=yes  >> /etc/samba/smb.conf
  sudo echo create mask=0777 >> /etc/samba/smb.conf
  sudo echo directory mask=0777 >> /etc/samba/smb.conf
  sudo echo public=yes >> /etc/samba/smb.conf
  sudo echo read only=no >> /etc/samba/smb.conf
  sudo systemctl enable smbd
  sudo systemctl restart smbd
  echo "You can access your DOS drive from another PC in your LAN browsing:"
  echo smb://$(hostname) or smb://$(hostname -I)
  echo "Enjoy"
  echo "- cttynul"
fi

# RPI Settings
if [ "$rpi_op" == "Y" ]
  then 
    #forcing 640x480 pi resolution
    sudo echo hdmi_group=1 >> /boot/config.txt
    sudo echo hdmi_mode=1 >> /boot/config.txt
fi

read -p "Do you want to install RetroPie? [Y|n] " option
if [ "$option" != "Y" ]
  then reboot_target
else
  sudo apt install -y git
  sudo apt install -y libsdl*dev
  git clone https://github.com/RetroPie/RetroPie-Setup.git
  chmod +x ./RetroPie-Setup/retropie_setup.sh
  ./RetroPie-Setup/retropie_setup.sh
  chmod 777 ~/RetroPie
  sudo echo [RetroPie] >> /etc/samba/smb.conf
  sudo echo path=~/RetroPie >> /etc/samba/smb.conf
  sudo echo writeable=yes  >> /etc/samba/smb.conf
  sudo echo create mask=0777 >> /etc/samba/smb.conf
  sudo echo directory mask=0777 >> /etc/samba/smb.conf
  sudo echo public=yes >> /etc/samba/smb.conf
  sudo echo read only=no >> /etc/samba/smb.conf
  sudo systemctl restart smbd
  echo "You can access your RetroPie folder from another PC in your LAN browsing:"
  echo smb://$(hostname) or smb://$(hostname -I)
  echo "To run Retropie you need to type emulationstation in your Rasbian CLI"
  echo "- cttynul"
  reboot_target
fi
