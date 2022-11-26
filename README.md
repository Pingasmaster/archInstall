# archInstall
How to install arch linux from scratch, because people need something working and clear.
This guide was inspired by [arch linux official guide](https://wiki.archlinux.org/title/Installation_guide), and [this one](https://itsfoss.com/install-arch-linux/). All the credits are theirs, I just added some more explanations and tips.
## Prerequisites:
- 1 hour of time, and some basic knowledge of computers
- Knowing how to follow instructions, don't miss a step, that's gonna create problems for sure
- One separate PC with an OS on it
- A working torrent / magnet client ont he separate PC (optionnal, you can also download arch iso via http)
- An internet connection (to download the torrent and to install packages after your brand new arch install)
- A computer with an empty drive and an internet connection via ethernet (assuming that wifi doesn't work without dirvers on linux) on wich to install arch (ALL DATA WILL BE ERASED DURING INSTALL)
- A usb drive (the fatest you can get, if you don't have one just buy an [sandisk extreme](https://www.amazon.com/dp/B08GYM5F8G/) for around 40 bucks, you will always need a fast usb trust me these are hard to find and very usefull)
## Preparing the install
- Download arch [official iso](https://archlinux.org/download/) from the [official website](https://archlinux.org/), either via torrent or via direct http download.
- Verify image integrity if you want, recommended on high threat model or poor internet connection, instructions are provided on the arch website. (optionnal)
- Download and install and open [rufus](https://rufus.ie/en/) (on windows) or [balenaetcher](https://www.balena.io/etcher/) (on linux)
- Select arch linux iso you just downloaded, plug in and select your usb drive and flash. Say yes to everything if you are using rufus
- Wait till the end
- Unplug the usb drive and plug it into the pc your want to install arch on
- Boot the pc on the usb drive, find the key you need to press at boot to show the boot menu (F12, F11, F9, F2, F1, DEL or ECHAP usually, refer to your motherboard manufacturer for this), select the usb and boot it
- Wait till it boots and you see this screen:
```
To install Arch Linux follow the installation guide:
https://wiki.archlinux.org/title/Installation_guide
For Wi-Fi, authenticate to the wireless network using the iwctl utility.
For mobile broadband (WWAN) modems, connect with the mmcli utility.
Ethernet, WLAN and WWAN interfaces using DHCP should work automatically.
After connecting to the internet, the installation guide can be accessed via the convenience script Installation_guide.
Last login: XXX XXX XX XX:XX:XX XXXX
root@archiso ~ # 
```
- Put the keyboard in your language configuration: enter `loadkeys de` or something similar with `de` being the two letter abbreviation of your language. To list all possibilities just enter `ls /usr/share/kbd/keymaps/**/*.map.gz`
- If you want to install arch via ssh for convenience (recommended, but optionnal), just type `ip addr` and your ip should appear in purple (three ip will appear, just ignore `127.0.0.1` and the one finished by `.255`) then type `passwd` and enter a password, on another machine open a terminal and type `ssh root@ip` replacing `ip` with your ip then re-enter the password previously set. You're then logged in! Just follow the guide from now on entering commands in the ssh window.
- 
