# Convert GitHub actor to uppercase and replace '-' with '_'
ACTOR=$(echo "$GITHUB_ACTOR" | tr '[:lower:]-' '[:upper:]_')

# Dynamically construct secret names
CLIENT_ID_SECRET_NAME="SFDX_${ACTOR}_CLIENT_ID"
USERNAME_SECRET_NAME="SFDX_${ACTOR}_USERNAME"

# Dynamically retrieve secrets from GitHub Actions environment
SANDBOX_CLIENT_ID=$(eval echo "\$${CLIENT_ID_SECRET_NAME}")
SANDBOX_USERNAME=$(eval echo "\$${USERNAME_SECRET_NAME}")

# Check if the secrets were retrieved successfully
if [ -z "$SANDBOX_CLIENT_ID" ] || [ -z "$SANDBOX_USERNAME" ]; then
  echo "Error: Unable to retrieve secrets for actor $ACTOR"
  exit 1
fi

# Export secrets to the environment variables for subsequent steps
echo "SANDBOX_CLIENT_ID=$SANDBOX_CLIENT_ID" >> $GITHUB_ENV
echo "SANDBOX_USERNAME=$SANDBOX_USERNAME" >> $GITHUB_ENV
echo "Using credentials for $SANDBOX_USERNAME...."
echo "Using credentials for $SANDBOX_ORG_ALIAS...."
echo "Using credentials for $SANDBOX_CLIENT_ID...."