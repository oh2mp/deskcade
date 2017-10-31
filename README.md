[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

This repository contains config files and some scripts for my "deskcade" project that is a 
Raspberry Pi based tabletop MAME arcade. If you plan to build a deskcade, you can see here how I did it.
These config files might not be suitable for your project without modification because of differences 
of hardware eg. display and controllers.

I used [Buildroot](https://buildroot.org/) and AdvanceMAME in my project. AdvanceMAME can be downloaded from [advancemame.it](http://www.advancemame.it/download)
I also used Press Start 2P font for Advance menu. It looks like old JAMMA game font and can be downloaded
freely from [1001freefonts.com](https://www.1001freefonts.com/press_start_2p.font). See advmenu.rc config file.

**NOTE: This is not a installable software package but a collection of scripts and config files if someone wants to do something similar. This is not suitable for beginners. If you want to make similar project, you should have knowledge how to make a Buildroot image and how to configure Linux. For beginners it's better just use some ready made game emulator distribution like [RetroPie](https://retropie.org.uk/) or [PiPlay](https://piplay.org/)**. The main reason for using Buildroot instead of eg. Raspbian was to get very fast booting OS.

## Directories:

### buildroot
  - Contains OS related things eg. buildroot config etc.

### script
  - Contains several utilities for setup and maintenance.

### config 
  - Contains my advmame config files from /home/pi/.advance These are of course just for information and might not be suitable for your project.

### util
  - Everything to put under /home/pi/.advance/util directory. The directory contains scripts that are run by fake emulator **"util"**.

### photos
  - Some photos of my deskcade for the wiki.
