#!/bin/bash

# Script for automatic installtion of vim like map to
# your selected layouts

#set -e # Exit after first error

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
    if  [ $? -eq 0 ];then
        echo "\"${ALTGR}\" is set for language \"${1}\""
        return 1
    else
        echo "\"${ALTGR}\" is not set for language \"${1}\""
        return 0
    fi
}


function set_keymap_file {
    if [ "${REMOVE}" -eq 0 ]; then
        echo "Removing vim like kyeboard functionality for \"${1}\" language."
        sudo sed --in-place "/${INCLUDE}/d" ${SYMBOLS}${1}
        check_setting $1
    else
        if check_setting $1 ; then
            echo "Installing vim like kyeboard functionality for \"${1}\" language."
            sudo sed --in-place=.backup "/${BEFORE}/a ${INCLUDE}" ${SYMBOLS}${1}
            check_setting $1
        fi
    fi
}


function usage {
    echo "
    No Language given given. At least 1 is required
    usage: ${1} [-r] [<lang1>|<lang2>|...]

    -r     removes installed settings
    "
}


# Main

if [ -n "$1" ]; then
    if [ "$1" == '-r' ]; then
        REMOVE=0
        languages=${@:2}
    else
        REMOVE=1
        languages=${@}
    fi
    if [[ "${#languages}" -eq 0 ]]; then
        echo ${#languages}
        usage ${0}
        exit 1
    fi
else
    usage ${0}
    exit 1
fi

check_sudo

for language in $languages; do 
    echo "####### Processing language: \"${language}\""
    if [ -f "${SYMBOLS}${language}" ]; then
            set_keymap_file $language
    else
        echo "There is no \"${language}\" language in \"${SYMBOLS}\""
    fi
    echo 
done


