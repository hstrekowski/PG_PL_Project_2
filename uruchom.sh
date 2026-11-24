#!/usr/bin/env bash
set -e
cd "$(dirname "$0")"

if ! command -v gst >/dev/null 2>&1; then
    echo "Brak GNU Smalltalk (gst). Zainstaluj go: bash instaluj_gst.sh" >&2
    exit 1
fi

KLASY="src/Pomocnicze.st src/Odcinki.st src/Trasa.st src/PlanerPodrozy.st"

case "${1:-demo}" in
    demo)  gst -g $KLASY src/main.st ;;
    testy) gst -g $KLASY src/testy.st ;;
    *)     echo "Użycie: bash uruchom.sh [demo|testy]" >&2; exit 1 ;;
esac
