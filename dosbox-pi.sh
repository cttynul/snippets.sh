#!\bin\bash

echo "    __             __                             __ "
echo ".--|  .-----.-----|  |--.-----.--.--.______.-----|__|"
echo "|  _  |  _  |__ --|  _  |  _  |_   _|______|  _  |  |"
echo "|_____|_____|_____|_____|_____|__.__|      |   __|__|"
echo " -cttynul                                  |__|      "

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

echo [PI ONLY] To console autologin see following steps
echo raspi-config
echo Choose option: 1 System Options
echo Choose option: S5 Boot / Auto Login
echo Choose option: B2 Console Autologin
echo Select Finish, and reboot the Raspberry Pi.
read -p "Do you want to turn your device into a Dosbox Machine? [Y|n]" option

if [ "$option" -ne "Y" ]
  then echo "Exiting..."
  exit
else
  read -p "Enter your user account (i.e. pi): " name
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
  chmod 777 /home/$name/DOS/C
  chmod 777 /home/$name/DOS/A
  echo [DOS Drive] >> /etc/samba/smb.conf
  echo path=/home/$name/DOS >> /etc/samba/smb.conf
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
