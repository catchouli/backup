# Stop on errors.
set -e

# Get script directory.
SCRIPT_DIR=$(dirname -- "$(readlink -f -- "$0")")
echo "Making monthly backup of $SCRIPT_DIR"
pushd $SCRIPT_DIR >/dev/null

# Make monthly backup.
mkdir -p monthly
cp backup-date.txt monthly/
rsync -av --delete databases monthly/
rsync -av --delete files monthly/

# Return to original directory.
popd >/dev/null
