#!/usr/bin/env bash
set -e
SUDO=""; [ "$(id -u)" -ne 0 ] && SUDO=sudo

if command -v gst >/dev/null 2>&1; then
    echo "gst jest już zainstalowany:"; gst --version | head -1; exit 0
fi

if command -v dnf >/dev/null 2>&1; then
    if $SUDO dnf install -y gnu-smalltalk 2>/dev/null; then gst --version | head -1; exit 0; fi
    echo ">> Brak pakietu gnu-smalltalk - buduję ze źródeł"
    $SUDO dnf install -y gcc make gawk wget xz tar zip unzip gmp-devel libffi-devel \
        libtool-ltdl-devel readline-devel zlib-devel
elif command -v apt-get >/dev/null 2>&1; then
    $SUDO apt-get update
    if $SUDO apt-get install -y gnu-smalltalk 2>/dev/null; then gst --version | head -1; exit 0; fi
    echo ">> Brak pakietu gnu-smalltalk - buduję ze źródeł"
    $SUDO apt-get install -y build-essential gawk wget xz-utils zip unzip libgmp-dev \
        libffi-dev libltdl-dev libreadline-dev zlib1g-dev
else
    echo "Nieobsługiwany system - zainstaluj gst ręcznie." >&2; exit 1
fi

KATALOG=$(mktemp -d)
cd "$KATALOG"
wget https://ftp.gnu.org/gnu/smalltalk/smalltalk-3.2.5.tar.xz || wget https://ftpmirror.gnu.org/smalltalk/smalltalk-3.2.5.tar.xz
tar xf smalltalk-3.2.5.tar.xz
cd smalltalk-3.2.5

export CFLAGS='-O2 -fcommon -std=gnu11 -Wno-error=incompatible-pointer-types -Wno-error=int-conversion -Wno-error=implicit-function-declaration'
./configure --prefix=/usr/local --disable-gtk --without-emacs --without-tk --disable-generational-gc
make -j"$(nproc)"
$SUDO make install
cd / && rm -rf "$KATALOG"

gst --version | head -1
echo "Gotowe. Uruchom projekt: bash uruchom.sh"
