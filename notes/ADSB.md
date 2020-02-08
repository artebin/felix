# ADS-B

Automatic Dependent Surveillance - Broadcast

## Packages for DVB-T
* rtl-sdr
* w-scan
* gqrx-sdr
* librtlsdr-dev libusb-1.0-0.dev #For compiling Dump1090

## Dump1090
Several projects:

* Salvatore Sanfilippo original dump1090 <https://github.com/antirez/dump1090> (BSD three clause license)

* Malcom Robb's fork <https://github.com/MalcolmRobb/dump1090> (BSD three clause license)

* FlightAware fork <https://github.com/MalcolmRobb/dump1090> (GPL license)

## Linux udev rule
Dump1090 needs a udev rule for the DVB-T. It is just a file to create in `/etc/udev/rules.d/rtl-sdr.rules`.

- Retrieve the VendorID and the ProductID with `lsusb`

- Create or update `/etc/udev/rules.d/rtl-sdr.rules`:
```
SUBSYSTEMS=="usb", ATTRS{idVendor}=="0bda", ATTRS{idProduct}=="2832", MODE:="0666"
```

- Make udev reload the rules:
```
sudo udevadm control --reload-rules
sudo udevadm trigger
```

- start dump1090 with `./dump1090 --interactive --net` and visit `http://localhost:8080`

## FlightRadar24
- retrieve fr24feed from <https://www.flightradar24.com/share-your-data>

- the binary executable is not perfoming a usable configuration on Ubuntu (at least Ubuntu 18.04). Maybe the install procedure failed, or it expects to find dump1090 in `/usr/lib/fr24`. It is no problem: (1) copy fr24feed in `/usr/bin`, (2) compile dump1090 and then copy dump1090 and gmap.html to `/usr/lib/fr24`. The systemd service file is also missing but it is no difficulty to write one.

- the argument `--interactive` of dump1090 prevent the feeding of FR24 for an unknown reason. Just use `--net` for having the map but remove `--interactive`.
