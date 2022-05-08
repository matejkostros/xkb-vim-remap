# About

Point of this mechanism is to utilize the power of XKB functionality to remap smaller keyboards to be able to use vim like navigation in almost every linux application.
It was tested under Fedora 34 running on Wayland however due to nature of XKB it should be compatible with X11 enabled distributions.

# Installation

1. Clone this repository
2. Copy `altgr_vim` file to X11 symbols directory

    ```shell
    cp ./altgr_vim /usr/share/X11/xkb/symbols/altgr_vim
    ```
3. Get your default language map
   ```shell
   language=${LANG:0:2}
   ```
4. Include your remap file to to your language keymap
   ```shell
   $ tail -3 /usr/share/X11/xkb/symbols/${language}
    default partial alphanumeric_keys
    xkb_symbols "basic" {
        include "altgr_vim(altgr-vim)"   ### <<< THIS LINE
    ```
5. Repeat it for all language maps you want. I use US and SK layouts. They are all available in symbols directory
    ```shell
    ls /usr/share/X11/xkb/symbols/
    ```
6. Logout and login back to reload keymap (or restart)

# Additional Resources and Notes
- This repository was inspired by askubuntu.com thread [Configure Caps Lock as AltGr and Arrows like in vim](https://askubuntu.com/questions/684459/configure-caps-lock-as-altgr-and-arrows-like-in-vim/898462#898462)
- To debug your input codes in X session use  `xev` which displays a small windos which if in focus displays all x-events in the console
- It is not recommended to remap Left Alt, as it is being used by some programs and it could make them less usefull.
- In general, it should be sufficient to go through the xkb symbols files and get inspired, however multikey shortcuts and macros are not supported
- Solution will not work for virtual consoles






