SCRIPT_DIR="$HOME/env/workplace/physera"
export CODE_DIR="$WORKSPACE"

## physera specific code that should run on startup
echo Setting up physera environment

# source company specific environment variables
source "$SCRIPT_DIR/.secrets"

# OKTA + general setup
export PHYS_AWS_PROFILE='OktaAdmin'



for f in "$SCRIPT_DIR/profile/foundational/"*;do source $f;done
for f in "$SCRIPT_DIR/profile/secondary/"*;do source $f;done


