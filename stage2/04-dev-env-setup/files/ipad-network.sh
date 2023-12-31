updateBootConfig() {
  echo "Configuring boot config"
  ! [ -f /boot/config.txt ] && touch /boot/config.txt
  ! cat /boot/config.txt | grep -q 'dtoverlay=dwc2' && echo -n "dtoverlay=dwc2" >> /boot/config.txt

  ! [ -f /boot/cmdline.txt ] && touch /boot/cmdline.txt
  ! cat /boot/cmdline.txt | grep -q 'modules-load=dwc2' && echo "modules-load=dwc2" >> /boot/cmdline.txt
  # ! cat /boot/cmdline.txt | grep -q 'modules-load=dwc2' && sed -i 's/$/ modules-load=dwc2/' /boot/cmdline.txt

  ! [ -f /etc/modules ] && touch /etc/modules
  ! cat /etc/modules | grep -q 'libcomposite' && echo "libcomposite" >> /etc/modules
  echo "Completed boot config"
}

setupNetwork() {
  echo "Configuring network for iPad connectivity"
  echo "Updating DHCP configuration"
  ! [ -f /etc/dhcpcd.conf ] && touch /etc/dhcpcd.conf
  ! cat /etc/dhcpcd.conf | grep -q 'denyinterfaces usb0' && echo "denyinterfaces usb0" >> /etc/dhcpcd.conf
  echo "Finished DHCP configuration"

  echo "Configuring dnsmasq for serving DHCP over usb-c"
  ! [ -d /etc/dnsmasq.d ] && mkdir -p /etc/dnsmasq.d
  ! [ -f /etc/dnsmasq.d/usb ] && touch /etc/dnsmasq.d/usb
  cat > /etc/dnsmasq.d/usb << EOF
interface=usb0
dhcp-range=11.100.0.2,11.100.0.6,255.255.255.248,1h
dhcp-option=3
leasefile-ro
EOF
  echo "Finished dnsmasq configuration"

  echo "Configuring network settings for usb-c port to static IP"
  ! [ -d /etc/network/interfaces.d ] && mkdir -p /etc/network/interfaces.d
  ! [ -f /etc/network/interfaces.d/usb0 ] && touch /etc/network/interfaces.d/usb0
  cat > /etc/network/interfaces.d/usb0 << EOF
auto usb0
allow-hotplug usb0
iface usb0 inet static
  address 11.100.0.1
  netmask 255.255.255.248
EOF
  echo "Finished static IP configuration"

  if [ -f /sloop/wpa_supplicant-wlan0.conf ]; then
    echo "Configuring wpa_supplicant for connectivity to networks"
    ! [ -d /etc/wpa_supplicant ] && mkdir -p /etc/wpa_supplicant
    cp /sloop/wpa_supplicant-wlan0.conf /etc/wpa_supplicant/

    echo "Configuring wlan0 to use dhcp"
    ! [ -f /etc/network/interfaces.d/wlan0 ] && touch /etc/network/interfaces.d/wlan0
    cat > /etc/network/interfaces.d/wlan0 << EOF
auto wlan0
allow-hotplug wlan0
iface wlan0 inet dhcp
wpa-conf /etc/wpa_supplicant/wpa_supplicant-wlan0.conf
EOF
    echo "Finished wlan0 dhcp configuration"
    echo "Finished wpa_supplicant configuration"
  else
    echo "No wpa_supplicant-wlan0.conf file found, skipping wlan0 configuration"
  fi

  echo "Configuring eth1, which will allow usb hotspot tethering to a smartphone"
  ! [ -f /etc/network/interfaces.d/eth1 ] && touch /etc/network/interfaces.d/eth1
  cat > /etc/network/interfaces.d/eth1 << EOF
allow-hotplug eth1
iface eth1 inet dhcp
EOF
  echo "Finished eth1 configuration"

  echo "Configuring cron to run the usb script at reboot, which allows iPad connectivity"
  ! [ -d /etc/cron.d ] && mkdir -p /etc/cron.d
  ! [ -f /etc/cron.d/ipad-usb ] && touch /etc/cron.d/ipad-usb
  cat > /etc/cron.d/ipad-usb << EOF
SHELL=/bin/bash

@reboot root /sloop/usb.sh
EOF
  # SUDO_USER="$FIRST_USER_NAME" sh -c 'crontab -l | { cat; echo "@reboot /bin/bash /sloop/usb.sh"; } | sort | uniq | crontab - '
  echo "Finished crontab configuration"
  echo "Completed network configuration"
}
