#!/bin/sh

USER="openttd"
HOME="/home/openttd"
SAVE_PATH="${HOME}/.openttd/save"

if [ ! "$(id -u ${USER})" -eq "$PUID" ]; then
    echo "Setting UID for ${USER} to ${PUID}"
    usermod -o -u "$PUID" ${USER}
fi
if [ ! "$(id -g ${USER})" -eq "$PGID" ]; then
    echo "Setting GID for ${USER} to ${PGID}"
    groupmod -o -g "$PGID" ${USER}
fi

chown -R ${USER}:${USER} ${HOME}

echo "
-----------------------------------
User:           ${USER}
  UID:          $(id -u ${USER})
  GID:          $(id -g ${USER})
  Home:         $(grep ${USER} /etc/passwd | cut -d':' -f6)
Game:
  Save path:    ${SAVE_PATH}
-----------------------------------
"

if [ -d ${SAVE_PATH}/autosave/ ]; then
    echo "Checking autosaves..."
    savegame=`ls -rt ${SAVE_PATH}/autosave/*.sav | tail -n1`
fi

if [ -z "$savegame" ]; then
    echo "No existing savegame found"
    echo "Creating a new game"
    su -l openttd -c "/usr/games/openttd -D -x"
    exit 0
else
    echo "Loading savegame at ${savegame}"
    su -l openttd -c "/usr/games/openttd -D -g ${savegame} -x"
    exit 0
fi
