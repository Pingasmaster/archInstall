# archInstall

How to install arch linux from scratch, because people need something working and clear.
This guide was inspired by [arch linux official guide](https://wiki.archlinux.org/title/Installation_guide), and [this one](https://itsfoss.com/install-arch-linux/). All the credits are theirs, I just added some more explanations and tips.
Concerning the fdisk formating part, `[ENTER]` is a press of the enter key, it is not to be written like that.
This is a somewhat complete and very detailed guide about each installation step.
If you only want the commands to copy / paste (install over ssh, see below), head over to the `commands_BIOS.md` file (on this repo).
This is the BIOS version, see README.md for the UEFI version.

## Prerequisites:

- 1 hour of time, and some basic knowledge of computers
- Knowing how to follow instructions and determination
- Another working PC (Linux or WIndows) with a torrent client if you want to download arch via torrent, but you can also download it via http
- An internet connection (to download the torrent and to install packages after your brand new arch install)
- The computer you want to install arch on with an empty drive and an internet connection via ethernet (trust me, just for initial setup it's __way__ easier). ALL DATA WILL BE ERASED DURING INSTALL, and it must meet arch linux requirements (amd64 (x86_64 64 bits) processor, 512Mb RAM,  2Gb hard drive for terminal-only install or else 20Gb hard drive)
- A usb drive of at least 8Gb (although more than 2gb will work, take the fatest you can get, if you don't have one just buy a [sandisk extreme pro with 128Gb](https://www.amazon.com/dp/B08GYM5F8G/) for around 40 bucks)

## Preparing the install

- Download arch [official iso](https://archlinux.org/download/) from the [official website](https://archlinux.org/), either via torrent or via direct http download
- Verify image integrity if you want, recommended on high threat model or poor internet connection, instructions are provided on the arch website (optionnal)
- Download and install and open [rufus](https://rufus.ie/en/) (on windows) or [balenaetcher](https://www.balena.io/etcher/) (on linux)
- Select the arch iso you just downloaded, plug in and select your usb drive and click flash. Say yes to everything if you are using rufus
- Wait until the end
- Unplug the usb drive and plug it into the pc your want to install arch on
- Boot the pc on the usb drive, find the key you need to press at boot to show the boot menu (F12, F11, F9, F2, F1, DEL or ECHAP usually, refer to your motherboard manufacturer for this), select the usb and boot it
- Wait until it boots and you see this screen:

```
To install Arch Linux follow the installation guide:
https://wiki.archlinux.org/title/Installation_guide
For Wi-Fi, authenticate to the wireless network using the iwctl utility.
For mobile broadband (WWAN) modems, connect with the mmcli utility.
Ethernet, WLAN and WWAN interfaces using DHCP should work automatically.
After connecting to the internet, the installation guide can be accessed via the convenience script Installation_guide.
root@archiso ~ # 
```

## Helpfull tips

- Put the keyboard in your language configuration: enter `loadkeys de` or something similar with `de` being the two letter abbreviation of your language. To list all possibilities just enter `ls /usr/share/kbd/keymaps/**/*.map.gz`
- If you want to install arch via ssh for convenience (recommended for people who know what they are doing, but optionnal), just type `ip a` and your ip should appear in purple (three ip will appear, just ignore `127.0.0.1` and the one finished by `.255`) then type `passwd` and enter a password, on another machine open a terminal and type `ssh root@ip` replacing `ip` with your ip then re-enter the password previously set. You're logged in! Just follow the guide from now on entering commands in the ssh window. It will be easier as you can copy / paste from here directly!

Now you have two possibilities:
- Your PC is old and doesn't support UEFI or doesn't support UEFI only boot: then install in the BIOS way.
- Your PC is recent, and does support UEFI only mode, then install the UEFI way.
You can go in the bios and search for an option called `UEFI only boot` and turn it on if you find it, this way booting will be more secure and cause less problems.
If you plan to install arch on a drive larger than 2 Terabytes, you need UEFI in order to boot into it.

To know if your PC support UEFI, enter `ls /sys/firmware/efi/efivars`: if it errors with `ls: cannot access '/sys/firmware/efi/efivars': No such file or directory` then your are booted in EFI, otherwise you are booted in UEFI.

This guide only shows how to install arch on an BIOS machine.

Verify that the clock is set to the right timezone `timedatectl status`, it is not type `timedatectl set-timezone Europe/Berlin` replacing `Europe/Berlin` by your own timezone (list available [here](https://timezonedb.com/time-zones)).

Assure that you only have __ONE AND ONLY ONE__ drive (exluding your usb key of course) plugged into your PC: the drive you want to install arch on. __THIS DRIVE MUST BE EMPTY__, here we will install arch by deleting everything else on the drive, if you want to do something else (like an install alongside Windows or something), research by yourself.

__Last warning: going further will ERASE ALL DATA!__

## Install

### Disk Preparation

Now that you've been warned, enter `fdisk -l` and identify your disk and its attribution letter (normally `/dev/sda`). Make sure you are targeting the right drive!
Then, type `fdisk /dev/sda` replacing `/dev/sda` by your own disk letter if incorrect.
Type `d[ENTER][ENTER]` to erase all partitions one by one until you see the message `No partition is defined yet!`, then type `w[ENTER]` to save changes.
Execute the tool again with `fdisk /dev/sda[ENTER]`, type `g[ENTER]` to create a new GPT partition table on your drive, `n[ENTER]` to create a new partition, `[ENTER]` to set it as the first partition, `[ENTER]` to set the first sector of the partition to the default one , `+512M[ENTER]` to set last sector of the partition 512 Mo after the end of the first sector (making this partition 512 Mo in size).

If it asks you `Created a new partition 1 of type 'Linux filesystem' and of size 512 MiB. Partition #1 contains a XXXX signature. Do you want to remove the signature? [Y]es/[N]o:`, then type `y[ENTER]`.

Type `t[ENTER]` to choose the partition type, `4[ENTER]` to choose a BIOS boot partition. The first partition is done, it is the partition that will allow the system to boot. We will now create the SWAP partition, a partition allowing your system to use some of your hard drive as your RAM. You can skip this step, but as it might create problems I encourage you to just set the partition size to 1 Gb instead of just not creating it.
Type `n[ENTER]`, `[ENTER]`, `[ENTER]`, `+numberG[ENTER]` replacing number with the number of gigabytes you want the swap partition to be.
Again, if asked to remove precedent partition signature, agree with `y[ENTER]`.
We will then change the partition type to swap: type `t[ENTER]`, `[ENTER]`, `19[ENTER]`.

To create the main partition where all the data will be, type `n[ENTER]`, `[ENTER]`, `[ENTER]`, `[ENTER]`.
Confirm all modifications with `w[ENTER]`. 
Create the filesystem on the partitions with `mkfs.ext4 /dev/sda3` or `mkfs.btrfs /dev/sda3` (depending on the filesystem you want to use) to create the main filesystem, and `mkswap /dev/sda2` to create the swap filesystem, and `mkfs.fat -F 32 /dev/sda1` to create the EFI filesystem.
Create the mounting directory for the main partition with `mkdir /mnt/3` , then mount it with `mount /dev/sda3 /mnt/3`.
Enable the swap volume with `swapon /dev/sda2`.

### Network preparation

There it is, our disk is partitionned correctly and almost ready to go. Now, let's test the internet connection with `ping -c 4 google.com`. If something is not right, make sure the ethernet cable is connected correctly, or connect via wifi. 

#### Wifi connection (optionnal)

Empty for now, will be updated

* Optional step: Update the mirror list

It is optional but strongly recommended as this file will be kept for the new install.
Now we will update the mirror list to a correct list for our contry with `pacman -Syy && pacman -S reflector` and then `reflector -c "DE" -f 12 -l 10 -n 12 --save /etc/pacman.d/mirrorlist`. Of course replace `DE` with your own country two-letter abbreviation. If errors appear, don't mind them: it is normal that some mirror don't work sometimes (they will not be included in the new mirror list).

### Base system install

Kernel is the base of your system, and you have three main version available: 
- linux, the normal version
- linux-zen, with better compatibility and a little bit more performance
- linux-hardened, with extra protections against exploits and all for paranoid people

Now, install arch linux's PGP keyring with `pacman -S archlinux-keyring` and install system base tools alongside your favorite arch kernel with `pacstrap -K /mnt/3 base linux-hardened linux-firmware`. Then generate the new file containing disks with `genfstab -U /mnt/3 >> /mnt/3/etc/fstab` and enter arch new install with `arch-chroot /mnt/3`. You are now logged into your new arch install!

### System settings

Set the time zone with `ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime` and synchronize hardware clock with `hwclock --systohc`. 

Install your favorite text manager (if you do not know one, type `pacman -Syu nano` and follow the rest of the tutorial).

Now edit the locales with `nano /etc/locale.gen` and uncomment (remove the # in front of the name of) locales that are needed (basically just uncomment the locale corresponding to your language) and __copy their name__, then run `locale-gen` to apply.
Then set the system language with `nano /etc/locale.conf` and then write `LANG=thenameofyourlocalethayoucopied`, save with CTRL+S and exit with CTRL+X. Then set the console language with `nano /etc/vconsole.conf` and write `KEYMAP=de` replacing `de` with the two-letter code of your country, save the file with CTRL+S then exit with CTRL+X.
Alright, hold with me it's almost the end!
Your just have to generate your hostname with `nano /etc/hostname` and then enter the name you want to give to your computer (no inspiration? alright, put `default` and that will do the trick).

### Allow your system to boot

Set the root password (EVEN if already done with ssh config, because remember it was not the same OS! If you do not know what it is, it is your password; you forget it, you lose access to your system. Don't forget it.) with `passwd` which will prompt you to enter your password two times.

Little reminder: this tutorial is for BIOS systems only, go read README.md if you want an UEFI tutorial. 

Install the grub bootloader (what will detect the OS and boot to it) with `pacman -S grub`. Now run `fdisk -l`, and again see which letter your disk is attributed to (/dev/sda or /dev/sdb or ...).
Now install grub with `grub-install /dev/sda`. Configure grub with `grub-mkconfig -o /boot/grub/grub.cfg`.

Your PC is ready to boot! There are two last additionnal steps which are very strongly recommended, but not mandatory if you know what your are doing.

## Very __IMPORTANT__!!

Note: Mediatek and realtek wifi cards are often not very well supported by arch linux; however, intel cards such as the AX200 will be natively (I have one)!

In order to have internet, install the network manager with `pacman -S networkmanager && systemctl enable NetworkManager` ! If you do not install that, you will NOT have any way to access internet (nor connect bluetooth devices), even with an ethernet cable plugged in or a wifi card.

To be able to connect bluetooth devices later on, first make sure you have a compatible bluetooth card (usually a wifi card does also bluetooth), then `pacman -S bluez bluez-tools`.

### Major optionnal step 1: create another user

Creating another user (than root) will not only be a ___lot___ more secure as you will be able to execute programs with less permissions, it will also be necessary if multiple people will use this PC. 

Install the famous root permissions manager for users with `pacman -S sudo`.

From here, the steps can be repeated as any times as needed to create as many users as you want.

Create another user with `useradd -m user` with `user` being the username that you can modify to suit your needs.
Set the user password with `passwd user`, and then you will be prompted to enter the user password two times.
Set user permisions to be root with `usermod -aG wheel,audio,video,storage user` and then edit the sudoers file with `EDITOR=nano`, `visudo` and then scroll down (using the down arrow key) until you see this line: `# %wheel ALL=(ALL:ALL) ALL`, then just remove the `#` at the beginning of the line, save with CTRL+S and exit with CTRL+X.

You have created an user, set his password, set correct permisions and allowed him to be root!

### Major optionnal step 2: Install a GUI

A Graphical User Interface, just as the name says, is made to be easier than a terminal for the average user; you probably don't want be stuck with the terminal for everyday tasks (unless you are a nerdy geek just as me), so bear with me just a little more and your hard earned arch system will be ready.

Even if you don't known what a GUI is, I encourage you to stop your install here and to go search what is a gui, and see which one you do prefer. If you are too lazy, or don't wanna be adventurous, just follow my steps. But any other website will tell you very well how to install a gui, so just search `install gui arch linux` and follow their steps.

My favourite GUI when i'm lazy is gnome, beacause it is beautifull without doing anything. But the most personnalisableby far is KDE, so choose what you want.

* Gnome install

Install gnome with `pacman -S xorg gnome --needed` and  enable it to boot with `systemctl enable gdm.service && systemctl enable NetworkManager.service`.

* KDE install

Install Xorg, KDE plasma Desktop environment, Wayland for KDE Plasma, and KDE applications (optionnal, you can remove `kde-applications` if you do not want them) with `pacman -Syu xorg plasma plasma-wayland-session kde-applications  --needed`.
Enable them at boot with `systemctl enable sddm.service`, and set the first login screen keyboard to your laguage with `localectl set-x11-keymap de`, replacing `de` by your locale. If for any reason this doesn't work, see [this arch wiki page on sddm.](https://wiki.archlinux.org/title/SDDM#SDDM_loads_only_US_keyboard_layout)

### Last steps

Once you're done with your install, just `exit`, `umount /mnt/3` (or if it gives an error wait a minute then do  `umount -l /mnt/3`)  and `shutdown now`. Don't forget to take out the usb so you can boot on your new drive. Enjoy your own arch linux!

