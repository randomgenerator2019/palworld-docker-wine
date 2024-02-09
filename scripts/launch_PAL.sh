#!/bin/bash

# Initialize environment variables
initialize_variables() {
    export DISPLAY=:0.0
    USERNAME=anonymous
    APPID=2394010
    PAL_DIR="/usr/games/.wine/drive_c/POK/Steam/steamapps/common/PalServer"
    PAL_CFG="$PAL_DIR/Pal/Saved/Config/WindowsServer/PalWorldSettings.ini"
    PERSISTENT_ACF_FILE="$PAL_DIR/appmanifest_$APPID.acf"
    WINEDEBUG=fixme-all,err-all
}

create_launcher_configs() {

  STARTCOMMAND=()

  if [ -n "${PORT}" ]; then
      STARTCOMMAND+=("-port=${PORT}")
  fi

  if [ -n "${QUERY_PORT}" ]; then
      STARTCOMMAND+=("-queryport=${QUERY_PORT}")
  fi

  if [ "${COMMUNITY}" = true ]; then
      STARTCOMMAND+=("EpicApp=PalServer")
  fi

  if [ "${MULTITHREADING}" = true ]; then
      STARTCOMMAND+=("-useperfthreads" "-NoAsyncLoadingThread" "-UseMultithreadForDS")
  fi

  if [ -n "${SERVER_NAME}" ]; then
      SERVER_NAME=$(escape_sed "$SERVER_NAME" | sed -e 's/^"\(.*\)"$/\1/' -e "s/^'\(.*\)'$/\1/")
      echo "SERVER_NAME=${SERVER_NAME}"
      sed -E -i "s/ServerName=\"[^\"]*\"/ServerName=\"$SERVER_NAME\"/" $PAL_CFG
  fi
  if [ -n "${SERVER_DESCRIPTION}" ]; then
      SERVER_DESCRIPTION=$(escape_sed "$SERVER_DESCRIPTION" | sed -e 's/^"\(.*\)"$/\1/' -e "s/^'\(.*\)'$/\1/")
      echo "SERVER_DESCRIPTION=${SERVER_DESCRIPTION}"
      sed -E -i "s/ServerDescription=\"[^\"]*\"/ServerDescription=\"$SERVER_DESCRIPTION\"/" $PAL_CFG
  fi
  if [ -n "${SERVER_PASSWORD}" ]; then
      SERVER_PASSWORD=$(sed -e 's/^"\(.*\)"$/\1/' -e "s/^'\(.*\)'$/\1/" <<< "$SERVER_PASSWORD")
      echo "SERVER_PASSWORD=${SERVER_PASSWORD}"
      sed -E -i "s/ServerPassword=\"[^\"]*\"/ServerPassword=\"$SERVER_PASSWORD\"/" $PAL_CFG
  fi
  if [ -n "${ADMIN_PASSWORD}" ]; then
      ADMIN_PASSWORD=$(sed -e 's/^"\(.*\)"$/\1/' -e "s/^'\(.*\)'$/\1/" <<< "$ADMIN_PASSWORD")
      echo "ADMIN_PASSWORD=${ADMIN_PASSWORD}"
      sed -E -i "s/AdminPassword=\"[^\"]*\"/AdminPassword=\"$ADMIN_PASSWORD\"/" $PAL_CFG
  fi
  if [ -n "${PLAYERS}" ]; then
      echo "PLAYERS=${PLAYERS}"
      sed -E -i "s/ServerPlayerMaxNum=[0-9]*/ServerPlayerMaxNum=$PLAYERS/" $PAL_CFG
  fi
  if [ -n "${PUBLIC_IP}" ]; then
      PUBLIC_IP=$(sed -e 's/^"\(.*\)"$/\1/' -e "s/^'\(.*\)'$/\1/" <<< "$PUBLIC_IP")
      echo "PUBLIC_IP=${PUBLIC_IP}"
      sed -E -i "s/PublicIP=\"[^\"]*\"/PublicIP=\"$PUBLIC_IP\"/" $PAL_CFG
  fi
  if [ -n "${PUBLIC_PORT}" ]; then
      echo "PUBLIC_PORT=${PUBLIC_PORT}"
      sed -E -i "s/PublicPort=[0-9]*/PublicPort=$PUBLIC_PORT/" $PAL_CFG
  fi
  if [ -n "${DIFFICULTY}" ]; then
      echo "DIFFICULTY=$DIFFICULTY"
      sed -E -i "s/Difficulty=[a-zA-Z]*/Difficulty=$DIFFICULTY/" $PAL_CFG
  fi
  if [ -n "${DAYTIME_SPEEDRATE}" ]; then
      echo "DAYTIME_SPEEDRATE=$DAYTIME_SPEEDRATE"
      sed -E -i "s/DayTimeSpeedRate=[+-]?([0-9]*[.])?[0-9]+/DayTimeSpeedRate=$DAYTIME_SPEEDRATE/" $PAL_CFG
  fi
  if [ -n "${NIGHTTIME_SPEEDRATE}" ]; then
      echo "NIGHTTIME_SPEEDRATE=$NIGHTTIME_SPEEDRATE"
      sed -E -i "s/NightTimeSpeedRate=[+-]?([0-9]*[.])?[0-9]+/NightTimeSpeedRate=$NIGHTTIME_SPEEDRATE/" $PAL_CFG
  fi
  if [ -n "${EXP_RATE}" ]; then
      echo "EXP_RATE=$EXP_RATE"
      sed -E -i "s/ExpRate=[+-]?([0-9]*[.])?[0-9]+/ExpRate=$EXP_RATE/" $PAL_CFG
  fi
  if [ -n "${PAL_CAPTURE_RATE}" ]; then
      echo "PAL_CAPTURE_RATE=$PAL_CAPTURE_RATE"
      sed -E -i "s/PalCaptureRate=[+-]?([0-9]*[.])?[0-9]+/PalCaptureRate=$PAL_CAPTURE_RATE/" $PAL_CFG
  fi
  if [ -n "${PAL_SPAWN_NUM_RATE}" ]; then
      echo "PAL_SPAWN_NUM_RATE=$PAL_SPAWN_NUM_RATE"
      sed -E -i "s/PalSpawnNumRate=[+-]?([0-9]*[.])?[0-9]+/PalSpawnNumRate=$PAL_SPAWN_NUM_RATE/" $PAL_CFG
  fi
  if [ -n "${PAL_DAMAGE_RATE_ATTACK}" ]; then
      echo "PAL_DAMAGE_RATE_ATTACK=$PAL_DAMAGE_RATE_ATTACK"
      sed -E -i "s/PalDamageRateAttack=[+-]?([0-9]*[.])?[0-9]+/PalDamageRateAttack=$PAL_DAMAGE_RATE_ATTACK/" $PAL_CFG
  fi
  if [ -n "${PAL_DAMAGE_RATE_DEFENSE}" ]; then
      echo "PAL_DAMAGE_RATE_DEFENSE=$PAL_DAMAGE_RATE_DEFENSE"
      sed -E -i "s/PalDamageRateDefense=[+-]?([0-9]*[.])?[0-9]+/PalDamageRateDefense=$PAL_DAMAGE_RATE_DEFENSE/" $PAL_CFG
  fi
  if [ -n "${PLAYER_DAMAGE_RATE_ATTACK}" ]; then
      echo "PLAYER_DAMAGE_RATE_ATTACK=$PLAYER_DAMAGE_RATE_ATTACK"
      sed -E -i "s/PlayerDamageRateAttack=[+-]?([0-9]*[.])?[0-9]+/PlayerDamageRateAttack=$PLAYER_DAMAGE_RATE_ATTACK/" $PAL_CFG
  fi
  if [ -n "${PLAYER_DAMAGE_RATE_DEFENSE}" ]; then
      echo "PLAYER_DAMAGE_RATE_DEFENSE=$PLAYER_DAMAGE_RATE_DEFENSE"
      sed -E -i "s/PlayerDamageRateDefense=[+-]?([0-9]*[.])?[0-9]+/PlayerDamageRateDefense=$PLAYER_DAMAGE_RATE_DEFENSE/" $PAL_CFG
  fi
  if [ -n "${PLAYER_STOMACH_DECREASE_RATE}" ]; then
      echo "PLAYER_STOMACH_DECREASE_RATE=$PLAYER_STOMACH_DECREASE_RATE"
      sed -E -i "s/PlayerStomachDecreaceRate=[+-]?([0-9]*[.])?[0-9]+/PlayerStomachDecreaceRate=$PLAYER_STOMACH_DECREASE_RATE/" $PAL_CFG
  fi
  if [ -n "${PLAYER_STAMINA_DECREASE_RATE}" ]; then
      echo "PLAYER_STAMINA_DECREASE_RATE=$PLAYER_STAMINA_DECREASE_RATE"
      sed -E -i "s/PlayerStaminaDecreaceRate=[+-]?([0-9]*[.])?[0-9]+/PlayerStaminaDecreaceRate=$PLAYER_STAMINA_DECREASE_RATE/" $PAL_CFG
  fi
  if [ -n "${PLAYER_AUTO_HP_REGEN_RATE}" ]; then
      echo "PLAYER_AUTO_HP_REGEN_RATE=$PLAYER_AUTO_HP_REGEN_RATE"
      sed -E -i "s/PlayerAutoHPRegeneRate=[+-]?([0-9]*[.])?[0-9]+/PlayerAutoHPRegeneRate=$PLAYER_AUTO_HP_REGEN_RATE/" $PAL_CFG
  fi
  if [ -n "${PLAYER_AUTO_HP_REGEN_RATE_IN_SLEEP}" ]; then
      echo "PLAYER_AUTO_HP_REGEN_RATE_IN_SLEEP=$PLAYER_AUTO_HP_REGEN_RATE_IN_SLEEP"
      sed -E -i "s/PlayerAutoHpRegeneRateInSleep=[+-]?([0-9]*[.])?[0-9]+/PlayerAutoHpRegeneRateInSleep=$PLAYER_AUTO_HP_REGEN_RATE_IN_SLEEP/" $PAL_CFG
  fi
  if [ -n "${PAL_STOMACH_DECREASE_RATE}" ]; then
      echo "PAL_STOMACH_DECREASE_RATE=$PAL_STOMACH_DECREASE_RATE"
      sed -E -i "s/PalStomachDecreaceRate=[+-]?([0-9]*[.])?[0-9]+/PalStomachDecreaceRate=$PAL_STOMACH_DECREASE_RATE/" $PAL_CFG
  fi
  if [ -n "${PAL_STAMINA_DECREASE_RATE}" ]; then
      echo "PAL_STAMINA_DECREASE_RATE=$PAL_STAMINA_DECREASE_RATE"
      sed -E -i "s/PalStaminaDecreaceRate=[+-]?([0-9]*[.])?[0-9]+/PalStaminaDecreaceRate=$PAL_STAMINA_DECREASE_RATE/" $PAL_CFG
  fi
  if [ -n "${PAL_AUTO_HP_REGEN_RATE}" ]; then
      echo "PAL_AUTO_HP_REGEN_RATE=$PAL_AUTO_HP_REGEN_RATE"
      sed -E -i "s/PalAutoHPRegeneRate=[+-]?([0-9]*[.])?[0-9]+/PalAutoHPRegeneRate=$PAL_AUTO_HP_REGEN_RATE/" $PAL_CFG
  fi
  if [ -n "${PAL_AUTO_HP_REGEN_RATE_IN_SLEEP}" ]; then
      echo "PAL_AUTO_HP_REGEN_RATE_IN_SLEEP=$PAL_AUTO_HP_REGEN_RATE_IN_SLEEP"
      sed -E -i "s/PalAutoHpRegeneRateInSleep=[+-]?([0-9]*[.])?[0-9]+/PalAutoHpRegeneRateInSleep=$PAL_AUTO_HP_REGEN_RATE_IN_SLEEP/" $PAL_CFG
  fi
  if [ -n "${BUILD_OBJECT_DAMAGE_RATE}" ]; then
      echo "BUILD_OBJECT_DAMAGE_RATE=$BUILD_OBJECT_DAMAGE_RATE"
      sed -E -i "s/BuildObjectDamageRate=[+-]?([0-9]*[.])?[0-9]+/BuildObjectDamageRate=$BUILD_OBJECT_DAMAGE_RATE/" $PAL_CFG
  fi
  if [ -n "${BUILD_OBJECT_DETERIORATION_DAMAGE_RATE}" ]; then
      echo "BUILD_OBJECT_DETERIORATION_DAMAGE_RATE=$BUILD_OBJECT_DETERIORATION_DAMAGE_RATE"
      sed -E -i "s/BuildObjectDeteriorationDamageRate=[+-]?([0-9]*[.])?[0-9]+/BuildObjectDeteriorationDamageRate=$BUILD_OBJECT_DETERIORATION_DAMAGE_RATE/" $PAL_CFG
  fi
  if [ -n "${COLLECTION_DROP_RATE}" ]; then
      echo "COLLECTION_DROP_RATE=$COLLECTION_DROP_RATE"
      sed -E -i "s/CollectionDropRate=[+-]?([0-9]*[.])?[0-9]+/CollectionDropRate=$COLLECTION_DROP_RATE/" $PAL_CFG
  fi
  if [ -n "${COLLECTION_OBJECT_HP_RATE}" ]; then
      echo "COLLECTION_OBJECT_HP_RATE=$COLLECTION_OBJECT_HP_RATE"
      sed -E -i "s/CollectionObjectHpRate=[+-]?([0-9]*[.])?[0-9]+/CollectionObjectHpRate=$COLLECTION_OBJECT_HP_RATE/" $PAL_CFG
  fi
  if [ -n "${COLLECTION_OBJECT_RESPAWN_SPEED_RATE}" ]; then
      echo "COLLECTION_OBJECT_RESPAWN_SPEED_RATE=$COLLECTION_OBJECT_RESPAWN_SPEED_RATE"
      sed -E -i "s/CollectionObjectRespawnSpeedRate=[+-]?([0-9]*[.])?[0-9]+/CollectionObjectRespawnSpeedRate=$COLLECTION_OBJECT_RESPAWN_SPEED_RATE/" $PAL_CFG
  fi
  if [ -n "${ENEMY_DROP_ITEM_RATE}" ]; then
      echo "ENEMY_DROP_ITEM_RATE=$ENEMY_DROP_ITEM_RATE"
      sed -E -i "s/EnemyDropItemRate=[+-]?([0-9]*[.])?[0-9]+/EnemyDropItemRate=$ENEMY_DROP_ITEM_RATE/" $PAL_CFG
  fi
  if [ -n "${DEATH_PENALTY}" ]; then
      echo "DEATH_PENALTY=$DEATH_PENALTY"
      sed -E -i "s/DeathPenalty=[a-zA-Z]*/DeathPenalty=$DEATH_PENALTY/" $PAL_CFG
  fi
  if [ -n "${ENABLE_PLAYER_TO_PLAYER_DAMAGE}" ]; then
      echo "ENABLE_PLAYER_TO_PLAYER_DAMAGE=$ENABLE_PLAYER_TO_PLAYER_DAMAGE"
      sed -E -i "s/bEnablePlayerToPlayerDamage=[a-zA-Z]*/bEnablePlayerToPlayerDamage=$ENABLE_PLAYER_TO_PLAYER_DAMAGE/" $PAL_CFG
  fi
  if [ -n "${ENABLE_FRIENDLY_FIRE}" ]; then
      echo "ENABLE_FRIENDLY_FIRE=$ENABLE_FRIENDLY_FIRE"
      sed -E -i "s/bEnableFriendlyFire=[a-zA-Z]*/bEnableFriendlyFire=$ENABLE_FRIENDLY_FIRE/" $PAL_CFG
  fi
  if [ -n "${ENABLE_INVADER_ENEMY}" ]; then
      echo "ENABLE_INVADER_ENEMY=$ENABLE_INVADER_ENEMY"
      sed -E -i "s/bEnableInvaderEnemy=[a-zA-Z]*/bEnableInvaderEnemy=$ENABLE_INVADER_ENEMY/" $PAL_CFG
  fi
  if [ -n "${ACTIVE_UNKO}" ]; then
      echo "ACTIVE_UNKO=$ACTIVE_UNKO"
      sed -E -i "s/bActiveUNKO=[a-zA-Z]*/bActiveUNKO=$ACTIVE_UNKO/" $PAL_CFG
  fi
  if [ -n "${ENABLE_AIM_ASSIST_PAD}" ]; then
      echo "ENABLE_AIM_ASSIST_PAD=$ENABLE_AIM_ASSIST_PAD"
      sed -E -i "s/bEnableAimAssistPad=[a-zA-Z]*/bEnableAimAssistPad=$ENABLE_AIM_ASSIST_PAD/" $PAL_CFG
  fi
  if [ -n "${ENABLE_AIM_ASSIST_KEYBOARD}" ]; then
      echo "ENABLE_AIM_ASSIST_KEYBOARD=$ENABLE_AIM_ASSIST_KEYBOARD"
      sed -E -i "s/bEnableAimAssistKeyboard=[a-zA-Z]*/bEnableAimAssistKeyboard=$ENABLE_AIM_ASSIST_KEYBOARD/" $PAL_CFG
  fi
  if [ -n "${DROP_ITEM_MAX_NUM}" ]; then
      echo "DROP_ITEM_MAX_NUM=$DROP_ITEM_MAX_NUM"
      sed -E -i "s/DropItemMaxNum=[0-9]*/DropItemMaxNum=$DROP_ITEM_MAX_NUM/" $PAL_CFG
  fi
  if [ -n "${DROP_ITEM_MAX_NUM_UNKO}" ]; then
      echo "DROP_ITEM_MAX_NUM_UNKO=$DROP_ITEM_MAX_NUM_UNKO"
      sed -E -i "s/DropItemMaxNum_UNKO=[0-9]*/DropItemMaxNum_UNKO=$DROP_ITEM_MAX_NUM_UNKO/" $PAL_CFG
  fi
  if [ -n "${BASE_CAMP_MAX_NUM}" ]; then
      echo "BASE_CAMP_MAX_NUM=$BASE_CAMP_MAX_NUM"
      sed -E -i "s/BaseCampMaxNum=[0-9]*/BaseCampMaxNum=$BASE_CAMP_MAX_NUM/" $PAL_CFG
  fi
  if [ -n "${BASE_CAMP_WORKER_MAXNUM}" ]; then
      echo "BASE_CAMP_WORKER_MAXNUM=$BASE_CAMP_WORKER_MAXNUM"
      sed -E -i "s/BaseCampWorkerMaxNum=[0-9]*/BaseCampWorkerMaxNum=$BASE_CAMP_WORKER_MAXNUM/" $PAL_CFG
  fi
  if [ -n "${DROP_ITEM_ALIVE_MAX_HOURS}" ]; then
      echo "DROP_ITEM_ALIVE_MAX_HOURS=$DROP_ITEM_ALIVE_MAX_HOURS"
      sed -E -i "s/DropItemAliveMaxHours=[+-]?([0-9]*[.])?[0-9]+/DropItemAliveMaxHours=$DROP_ITEM_ALIVE_MAX_HOURS/" $PAL_CFG
  fi
  if [ -n "${AUTO_RESET_GUILD_NO_ONLINE_PLAYERS}" ]; then
      echo "AUTO_RESET_GUILD_NO_ONLINE_PLAYERS=$AUTO_RESET_GUILD_NO_ONLINE_PLAYERS"
      sed -E -i "s/bAutoResetGuildNoOnlinePlayers=[a-zA-Z]*/bAutoResetGuildNoOnlinePlayers=$AUTO_RESET_GUILD_NO_ONLINE_PLAYERS/" $PAL_CFG
  fi
  if [ -n "${AUTO_RESET_GUILD_TIME_NO_ONLINE_PLAYERS}" ]; then
      echo "AUTO_RESET_GUILD_TIME_NO_ONLINE_PLAYERS=$AUTO_RESET_GUILD_TIME_NO_ONLINE_PLAYERS"
      sed -E -i "s/AutoResetGuildTimeNoOnlinePlayers=[+-]?([0-9]*[.])?[0-9]+/AutoResetGuildTimeNoOnlinePlayers=$AUTO_RESET_GUILD_TIME_NO_ONLINE_PLAYERS/" $PAL_CFG
  fi
  if [ -n "${GUILD_PLAYER_MAX_NUM}" ]; then
      echo "GUILD_PLAYER_MAX_NUM=$GUILD_PLAYER_MAX_NUM"
      sed -E -i "s/GuildPlayerMaxNum=[0-9]*/GuildPlayerMaxNum=$GUILD_PLAYER_MAX_NUM/" $PAL_CFG
  fi
  if [ -n "${PAL_EGG_DEFAULT_HATCHING_TIME}" ]; then
      echo "PAL_EGG_DEFAULT_HATCHING_TIME=$PAL_EGG_DEFAULT_HATCHING_TIME"
      sed -E -i "s/PalEggDefaultHatchingTime=[+-]?([0-9]*[.])?[0-9]+/PalEggDefaultHatchingTime=$PAL_EGG_DEFAULT_HATCHING_TIME/" $PAL_CFG
  fi
  if [ -n "${WORK_SPEED_RATE}" ]; then
      echo "WORK_SPEED_RATE=$WORK_SPEED_RATE"
      sed -E -i "s/WorkSpeedRate=[+-]?([0-9]*[.])?[0-9]+/WorkSpeedRate=$WORK_SPEED_RATE/" $PAL_CFG
  fi
  if [ -n "${IS_MULTIPLAY}" ]; then
      echo "IS_MULTIPLAY=$IS_MULTIPLAY"
      sed -E -i "s/bIsMultiplay=[a-zA-Z]*/bIsMultiplay=$IS_MULTIPLAY/" $PAL_CFG
  fi
  if [ -n "${IS_PVP}" ]; then
      echo "IS_PVP=$IS_PVP"
      sed -E -i "s/bIsPvP=[a-zA-Z]*/bIsPvP=$IS_PVP/" $PAL_CFG
  fi
  if [ -n "${CAN_PICKUP_OTHER_GUILD_DEATH_PENALTY_DROP}" ]; then
      echo "CAN_PICKUP_OTHER_GUILD_DEATH_PENALTY_DROP=$CAN_PICKUP_OTHER_GUILD_DEATH_PENALTY_DROP"
      sed -E -i "s/bCanPickupOtherGuildDeathPenaltyDrop=[a-zA-Z]*/bCanPickupOtherGuildDeathPenaltyDrop=$CAN_PICKUP_OTHER_GUILD_DEATH_PENALTY_DROP/" $PAL_CFG
  fi
  if [ -n "${ENABLE_NON_LOGIN_PENALTY}" ]; then
      echo "ENABLE_NON_LOGIN_PENALTY=$ENABLE_NON_LOGIN_PENALTY"
      sed -E -i "s/bEnableNonLoginPenalty=[a-zA-Z]*/bEnableNonLoginPenalty=$ENABLE_NON_LOGIN_PENALTY/" $PAL_CFG
  fi
  if [ -n "${ENABLE_FAST_TRAVEL}" ]; then
      echo "ENABLE_FAST_TRAVEL=$ENABLE_FAST_TRAVEL"
      sed -E -i "s/bEnableFastTravel=[a-zA-Z]*/bEnableFastTravel=$ENABLE_FAST_TRAVEL/" $PAL_CFG
  fi
  if [ -n "${IS_START_LOCATION_SELECT_BY_MAP}" ]; then
      echo "IS_START_LOCATION_SELECT_BY_MAP=$IS_START_LOCATION_SELECT_BY_MAP"
      sed -E -i "s/bIsStartLocationSelectByMap=[a-zA-Z]*/bIsStartLocationSelectByMap=$IS_START_LOCATION_SELECT_BY_MAP/" $PAL_CFG
  fi
  if [ -n "${EXIST_PLAYER_AFTER_LOGOUT}" ]; then
      echo "EXIST_PLAYER_AFTER_LOGOUT=$EXIST_PLAYER_AFTER_LOGOUT"
      sed -E -i "s/bExistPlayerAfterLogout=[a-zA-Z]*/bExistPlayerAfterLogout=$EXIST_PLAYER_AFTER_LOGOUT/" $PAL_CFG
  fi
  if [ -n "${ENABLE_DEFENSE_OTHER_GUILD_PLAYER}" ]; then
      echo "ENABLE_DEFENSE_OTHER_GUILD_PLAYER=$ENABLE_DEFENSE_OTHER_GUILD_PLAYER"
      sed -E -i "s/bEnableDefenseOtherGuildPlayer=[a-zA-Z]*/bEnableDefenseOtherGuildPlayer=$ENABLE_DEFENSE_OTHER_GUILD_PLAYER/" $PAL_CFG
  fi
  if [ -n "${COOP_PLAYER_MAX_NUM}" ]; then
      echo "COOP_PLAYER_MAX_NUM=$COOP_PLAYER_MAX_NUM"
      sed -E -i "s/CoopPlayerMaxNum=[0-9]*/CoopPlayerMaxNum=$COOP_PLAYER_MAX_NUM/" $PAL_CFG
  fi
  if [ -n "${REGION}" ]; then
      REGION=$(sed -e 's/^"\(.*\)"$/\1/' -e "s/^'\(.*\)'$/\1/" <<< "$REGION")
      echo "REGION=$REGION"
      sed -E -i "s/Region=\"[^\"]*\"/Region=\"$REGION\"/" $PAL_CFG
  fi
  if [ -n "${USEAUTH}" ]; then
      echo "USEAUTH=$USEAUTH"
      sed -E -i "s/bUseAuth=[a-zA-Z]*/bUseAuth=$USEAUTH/" $PAL_CFG
  fi
  if [ -n "${BAN_LIST_URL}" ]; then
      BAN_LIST_URL=$(sed -e 's/^"\(.*\)"$/\1/' -e "s/^'\(.*\)'$/\1/" <<< "$BAN_LIST_URL")
      echo "BAN_LIST_URL=$BAN_LIST_URL"
      sed -E -i "s~BanListURL=\"[^\"]*\"~BanListURL=\"$BAN_LIST_URL\"~" $PAL_CFG
  fi
  if [ -n "${RCON_ENABLED}" ]; then
      echo "RCON_ENABLED=${RCON_ENABLED}"
      sed -i "s/RCONEnabled=[a-zA-Z]*/RCONEnabled=$RCON_ENABLED/" $PAL_CFG
  fi
  if [ -n "${RCON_PORT}" ]; then
      echo "RCON_PORT=${RCON_PORT}"
      sed -i "s/RCONPort=[0-9]*/RCONPort=$RCON_PORT/" $PAL_CFG
  fi
  # Configure RCON settings
  touch $PAL_DIR/Pal/Saved/Config/WindowsServer/rcon.yaml
  cat >$PAL_DIR/Pal/Saved/Config/WindowsServer/rcon.yaml  <<EOL
default:
  address: "127.0.0.1:${RCON_PORT}"
  password: ${ADMIN_PASSWORD}
EOL

}

# Get the build ID from the appmanifest.acf file
get_build_id_from_acf() {
    if [[ -f "$PERSISTENT_ACF_FILE" ]]; then
        local build_id=$(grep -E "^\s+\"buildid\"\s+" "$PERSISTENT_ACF_FILE" | grep -o '[[:digit:]]*')
        echo "$build_id"
    else
        echo ""
    fi
}

# Get the current build ID from SteamCMD API
get_current_build_id() {
    local build_id=$(curl -sX GET "https://api.steamcmd.net/v1/info/$APPID" | jq -r ".data.\"$APPID\".depots.branches.public.buildid")
    echo "$build_id"
}

install_server() {
    local saved_build_id=$(get_build_id_from_acf)
    local current_build_id=$(get_current_build_id)

    if [ -z "$saved_build_id" ] || [ "$saved_build_id" != "$current_build_id" ]; then
        echo "New server installation or update required..."
        touch /usr/games/updating.flag
        echo "Current build ID is $current_build_id, initiating installation/update..."
        sudo -u games wine "$PROGRAM_FILES/Steam/steamcmd.exe" +login "$USERNAME" +force_install_dir "$PAL_DIR" +app_update "$APPID" +@sSteamCmdForcePlatformType windows +quit
        # Copy the acf file to the persistent volume
        cp "/usr/games/.wine/drive_c/POK/Steam/steamapps/appmanifest_$APPID.acf" "$PERSISTENT_ACF_FILE"
        echo "Installation or update completed successfully."
        rm -f /usr/games/updating.flag
    else
        echo "No update required. Server build ID $saved_build_id is up to date."
    fi
}

update_server() {
    local saved_build_id=$(get_build_id_from_acf)
    local current_build_id=$(get_current_build_id)

    if [ -z "$saved_build_id" ] || [ "$saved_build_id" != "$current_build_id" ]; then
        echo "Server update detected..."
        touch /usr/games/updating.flag
        echo "Updating server to build ID $current_build_id from $saved_build_id..."
        sudo -u games wine "$PROGRAM_FILES/Steam/steamcmd.exe" +login "$USERNAME" +force_install_dir "$ASA_DIR" +app_update "$APPID" +@sSteamCmdForcePlatformType windows +quit
        # Copy the acf file to the persistent volume
        cp "/usr/games/.wine/drive_c/POK/Steam/steamapps/appmanifest_$APPID.acf" "$PERSISTENT_ACF_FILE"
        echo "Server update completed successfully."
        rm -f /usr/games/updating.flag
    else
        echo "Server is already running the latest build ID $saved_build_id. Proceeding to start the server."
    fi
}



# Function to handle graceful shutdown
shutdown_handler() {
    ls -alh $PAL_DIR/Pal/Saved/Config/WindowsServer/rcon.yaml
    echo "path: $PAL_DIR/Pal/Saved/Config/WindowsServer/rcon.yaml"
    cat $PAL_DIR/Pal/Saved/Config/WindowsServer/rcon.yaml
    rcon-cli -c $PAL_DIR/Pal/Saved/Config/WindowsServer/rcon.yaml "broadcast Immediate server shutdown initiated. Saving the world..."
    echo "Saving the world..."
    rcon-cli -c $PAL_DIR/Pal/Saved/Config/WindowsServer/rcon.yaml save
    echo "Initiating graceful shutdown..."
    rcon-cli -c $PAL_DIR/Pal/Saved/Config/WindowsServer/rcon.yaml "shutdown 1"
    # Initial delay to avoid catching a previous save message
    echo "Waiting a few seconds before checking for save completion..."
    sleep 15  # Initial delay, can be adjusted based on server behavior
    # Wait for save to complete
    echo "World saved. Shutting down the server..."
    exit 0
}

# Trap SIGTERM
trap 'shutdown_handler' SIGTERM

start_server() {
  printf "\e[0;32m*****STARTING SERVER*****\e[0m\n"
  echo "sudo -u games wine $PAL_DIR/Pal/Binaries/Win64/PalServer-Win64-Test-Cmd.exe $STARTCOMMAND"
  sudo -u games wine $PAL_DIR/Pal/Binaries/Win64/PalServer-Win64-Test-Cmd.exe $STARTCOMMAND 2>/dev/null &
  SERVER_PID=$!
  echo "Server process started with PID: $SERVER_PID"
  echo $SERVER_PID > /usr/games/pal_server.pid
  echo "PID $SERVER_PID written to /usr/games/pal_server.pid"
  # Wait for the server process to exit
  wait $SERVER_PID
}


# Main function
main() {
    initialize_variables
    install_server
    update_server
    create_launcher_configs
    start_server
}

# Start the main execution
main
