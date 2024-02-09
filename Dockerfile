# Use an image that has Wine installed to run Windows applications
FROM scottyhardy/docker-wine

# Add ARG for PUID and PGID with a default value
ARG PUID=1001
ARG PGID=1001

# Arguments and environment variables
ENV PUID ${PUID}
ENV PGID ${PGID}
ENV WINEPREFIX /usr/games/.wine
ENV WINEDEBUG fixme-all,err-all
ENV PROGRAM_FILES "$WINEPREFIX/drive_c/POK"
ENV PAL_DIR "$PROGRAM_FILES/Steam/steamapps/common/PalServer/"

ENV PORT= \
    PUID=1001 \
    PGID=1001 \
    PLAYERS= \
    MULTITHREADING=false \
    COMMUNITY=false \
    PUBLIC_IP= \
    PUBLIC_PORT= \
    SERVER_PASSWORD= \
    SERVER_NAME= \
    ADMIN_PASSWORD= \
    UPDATE_ON_BOOT=true \
    RCON_ENABLED=true \
    RCON_PORT=25575 \
    QUERY_PORT=27015 \
    TZ=UTC \
    SERVER_DESCRIPTION= \
    BACKUP_ENABLED=true \
    DELETE_OLD_BACKUPS=false \
    OLD_BACKUP_DAYS=30 \
    BACKUP_CRON_EXPRESSION="0 0 * * *" \
    AUTO_UPDATE_ENABLED=false \
    AUTO_UPDATE_CRON_EXPRESSION="0 * * * *" \
    AUTO_UPDATE_WARN_MINUTES=30


# Create required directories
RUN mkdir -p "$PROGRAM_FILES"

# Change user shell and set ownership
RUN usermod --shell /bin/bash games && chown -R games:games /usr/games

# Modify user and group IDs
RUN groupmod -o -g $PGID games && \
    usermod -o -u $PUID -g games games

# Install jq, curl, and dependencies for rcon-cli
USER root

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN wget -q https://github.com/gorcon/rcon-cli/releases/download/v0.10.3/rcon-0.10.3-amd64_linux.tar.gz -O - | tar -xz && \
    mv rcon-0.10.3-amd64_linux/rcon /usr/bin/rcon-cli

# Switch to games user
USER games

# Set the working directory
WORKDIR /usr/games

# Install SteamCMD
RUN wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip \
    && unzip steamcmd.zip -d "$PROGRAM_FILES/Steam" \
    && rm steamcmd.zip

# Debug: Output the directory structure for Program Files to debug
RUN ls -R "$WINEPREFIX/drive_c/POK"

# Install Steam app dependencies
RUN ln -s "$PROGRAM_FILES/Steam" /usr/games/Steam && \
    mkdir -p /usr/games/Steam/steamapps/common && \
    find /usr/games/Steam/steamapps/common -maxdepth 0 -not -name "Steamworks Shared"

# Explicitly set the ownership of WINEPREFIX directory to games
RUN chown -R games:games "$WINEPREFIX"

# Switch back to root for final steps
USER root

# Copy scripts folder into the container
COPY scripts/ /usr/games/scripts/
# Copy defaults folder into the container
COPY defaults/ /usr/games/defaults/

# Remove Windows-style carriage returns from the scripts
RUN sed -i 's/\r//' /usr/games/scripts/*.sh

# Make scripts executable
RUN chmod +x /usr/games/scripts/*.sh

EXPOSE ${PORT} ${RCON_PORT}
# Set the entry point to Supervisord
ENTRYPOINT ["/usr/games/scripts/init.sh"]
