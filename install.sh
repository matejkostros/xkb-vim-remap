#!/bin/bash

# Script for automatic installtion of vim like map to
# your selected layouts

# Constants
SYMBOLS="/usr/share/X11/xkb/symbols/"
ALTGR="altgr_vim" 
INCLUDE="\    include \"${ALTGR}(altgr-vim)\""
BEFORE="xkb_symbols \"basic\" {"

# Functions
function check_sudo {
    if [[ "$EUID" = 0 ]]; then
        echo "(1) already root"
    else
        sudo -k # make sure to ask for password on next sudo
        if sudo true; then
            echo "(2) correct password"
        else
            echo "(3) wrong password"
            exit 1
        fi
    fi
}
function check_setting {
    grep "${ALTGR}" "${SYMBOLS}${1}" 2>&1 >> /dev/null
    #if grep "${ALTGR}" "${SYMBOLS}${1}" 2>&1 >> /dev/null; then
    if  [ $? -eq 0 ];then
        echo "\"${ALTGR}\" is set for language \"${1}\""
        return 1
    else
        echo "\"${ALTGR}\" is not set for language  \"${1}\""
        return 0
    fi
}

function include_keymap_file {
    sudo sed --in-place=backup "/${BEFORE}/a ${INCLUDE}" ${SYMBOLS}${1}
}

# Main 
check_sudo

if [ -n "$1" ]; then
    languages=${@}
    test
else
    echo "
    No Language given given. At least 1 is required
    usage: ${0} [<lang1>|<lang2>|...]
    "
    exit 0
fi

for language in $languages; do 
    echo "####### Processing language: \"${language}\""
    if [ -f "${SYMBOLS}${language}" ]; then
        
        if check_setting $language;then
            echo "Installing vim like kyeboard functionality for \"$language\" language."
            include_keymap_file $language
            check_setting $language
        fi

    else
        echo "There is no \"${language}\" language in \"${SYMBOLS}\""
    fi
    echo 
done
#for language in 









