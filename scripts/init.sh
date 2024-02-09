#!/bin/bash

# Get PUID and PGID from environment variables, or default to 1001
PUID=${PUID:-1001}
PGID=${PGID:-1001}

# Validating PUID and PGID
if ! [[ "$PUID" =~ ^[0-9]+$ ]]; then
    echo "Invalid PUID: $PUID. Must be a number."
    exit 1
fi

if ! [[ "$PGID" =~ ^[0-9]+$ ]]; then
    echo "Invalid PGID: $PGID. Must be a number."
    exit 1
fi


PAL_DIR="/usr/games/.wine/drive_c/POK/Steam/steamapps/common/PalServer"
CFG_DIR="$PAL_DIR/Pal/Saved/Config/WindowsServer"

# Fix games user uid & gid then re set the owner of wine folders
echo "Setting games user ID and group ID"
groupmod -o -g $PGID games || { echo "Failed to modify group ID"; exit 1; }
usermod -o -u $PUID -g games games || { echo "Failed to modify user ID"; exit 1; }
chown -R games:games "$WINEPREFIX"

echo "Creating directories and setting permissions"
for DIR in "$PAL_DIR" "$CFG_DIR"; do
    if [ ! -d "$DIR" ]; then
        mkdir -p "$DIR" || { echo "Failed to create directory $DIR"; exit 1; }
    fi
    chown -R $PUID:$PGID "$DIR" || { echo "Failed to set ownership for $DIR"; exit 1; }
    chmod -R 755 "$DIR" || { echo "Failed to set permissions for $DIR"; exit 1; }
done

copy_default_configs() {
    # Copy GameUserSettings.ini if it does not exist
    if [ ! -f "${CFG_DIR}/GameUserSettings.ini" ]; then
        cp /usr/games/defaults/* "$CFG_DIR"
        chown -R $PUID:$PGID "${CFG_DIR}"
        chmod -R 755 "${CFG_DIR}"
    fi

}
copy_default_configs
# echo "Starting Palworld server monitoring script"
# # Start monitor_ark_server.sh in the background
# /usr/games/scripts/monitor_pal_server.sh &
#
echo "Starting main application"
# Continue with the main application
exec /usr/games/scripts/launch_PAL.sh
