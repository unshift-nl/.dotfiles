#!/bin/sh
os=$1
echo ''

install_polybar () {
    local enable_alsa="ON"
    local enable_i3="OFF"
    local enable_network="ON"
    local enable_mpd="OFF"
    local enable_curl="ON"



    sudo rm .tmp -r
    mkdir .tmp
    git clone --branch 2.4.3 --recursive https://github.com/jaagr/polybar .tmp
    mkdir .tmp/build
    cd .tmp/build

    cmake                                         \
        -DCMAKE_BUILD_TYPE=Release                \
        -DENABLE_ALSA:BOOL="${enable_alsa}"       \
        -DENABLE_I3:BOOL="${enable_i3}"           \
        -DENABLE_MPD:BOOL="${enable_mpd}"         \
        -DENABLE_NETWORK:BOOL="${enable_network}" \
        -DENABLE_CURL:BOOL="${enable_curl}"       \
        .. || msg_err "Failed to generate build... read output to get a hint of what went wrong"

    sudo make install
    cd -
    sudo rm .tmp -r
}

if [ X"$os" = X"u" ]; then
    echo 'Installing polybar for Ubuntu-like systems'
    echo ''
    sudo apt-get -qq install cmake cmake-data libfontconfig1-dev libfreetype6-dev libghc-x11-xft-dev libx11-xcb-dev libxcb1-dev libxcb-ewmh-dev libxcb-icccm4-dev libxcb-image0-dev libxcb-randr0-dev libxcb-util0-dev libxcb-xkb-dev pkg-config python-xcbgen xcb-proto

    install_polybar
fi
if [ X"$os" = X"a" ]; then
    echo 'Installing polybar for Arch systems'
    echo ''
    sudo pacman -S cmake libXft python2 xcb-proto xcb-util-wm xcb-util-image also-lib wireless_tools --noconfirm --needed

    install_polybar
fi



echo ''
