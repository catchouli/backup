# Stop on errors.
set -e

# Read env vars from .env file.
set -o allexport
source .env
set +o allexport

echo $B2_APP_KEY
