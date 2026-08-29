mkdir -p /media/lohk/AzureMinecraftHost
sshfs -o IdentityFile="$MINECRAFT_KEY_FILE_PATH" "$MINECRAFT_CONNECTION_ADDR":/home/lohk /media/lohk/AzureMinecraftHost