# Stop on errors.
set -e

# Get script directory.
SCRIPT_DIR=$(dirname -- "$(readlink -f -- "$0")")
echo "Making weekly backup of $SCRIPT_DIR"
pushd $SCRIPT_DIR >/dev/null

# Make weekly backup.
mkdir -p weekly
cp backup-date.txt weekly/
rsync -av --delete databases weekly/
rsync -av --delete files weekly/

# Return to original directory.
popd >/dev/null
