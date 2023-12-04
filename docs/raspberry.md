# Setting up Wi-Fi

1. Edit `/etc/wpa_supplicant/wpa_supplicant.conf`
2. Set the link down
3. Kill the wpa_supplicant process
4. Run the wpa_supplicant process again
5. Set the link up

```
$ sudo -e /etc/wpa_supplicant/wpa_supplicant.conf

$ ip link set dev wlan0 down

# Find the PID of 'wpa_supplicant -B -c/etc/wpa_supplicant/wpa_supplicant.conf -iwlan0'
$ ps aux | grep wpa
$ sudo kill <PID>

$ sudo wpa_supplicant -B -c/etc/wpa_supplicant/wpa_supplicant.conf -iwlan0

$ sudo ip link set dev wlan0 up
```

