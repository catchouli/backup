# Databases to back up.
declare -a DATABASES=("talkhaus" "talkhaus_wiki")

# Stop on errors.
set -e

# Get script directory.
SCRIPT_DIR=$(dirname -- "$(readlink -f -- "$0")")
echo "Backing up $SCRIPT_DIR"
pushd $SCRIPT_DIR >/dev/null

# Read env vars from .env file.
set -o allexport
source .env
set +o allexport

# Write backup date to file.
echo "$(date)" > backup-date.txt

# Back up files.
echo "Backing up volumes"
mkdir -p files
rsync -av --delete /home/cat/volumes/talkhaus files/volumes
rsync -av --delete /home/cat/volumes/wiki files/volumes

# Back up each database.
echo "Backing up databases"
for DBNAME in "${DATABASES[@]}"
do
    echo "    Backing up database '$DBNAME'"

    # Create directory for database.
    mkdir -p databases
    pushd databases >/dev/null

    # Back up database to .sql file.
    kubectl exec -it talkhaus-mysql-0 -- mysqldump --lock-tables=false --single-transaction=true \
	    -ubackup -p$MYSQL_PASS "$DBNAME" > "$DBNAME.sql"

    # Return to previous directory.
    popd >/dev/null
done

# Sync directory to backblaze.
echo "Syncing to backblaze"
rclone sync -P --exclude .env --exclude .git/ . sleech-backup:sleech-backup

# Return to original directory.
popd >/dev/null
