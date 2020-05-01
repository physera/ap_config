SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"


## physera specific code that should run on startup
echo Setting up physera environment

# source company specific environment variables
source "$SCRIPT_DIR/.secrets"

# OKTA + general setup
export PHYS_AWS_PROFILE='OktaAdmin'


command -v gimme-aws-creds || pip install --upgrade wheel gimme-aws-creds && asdf reshim python
command -v gimme-aws-creds || echo "Failed to install gimme-aws-creds, possible problem with pip"

clearcreds() {
    echo "## Removing old credentials"
    unset AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN AWS_SECURITY_TOKEN
}

getcreds() {
    echo "## Getting your aws credentials for the next 12 hours"
    creds_json=$(gimme-aws-creds)
    echo "## Exporting your credentials as envvars"
    export AWS_ACCESS_KEY_ID=$(echo $creds_json | jq -r .credentials.aws_access_key_id)
    export AWS_SECRET_ACCESS_KEY=$(echo $creds_json | jq -r .credentials.aws_secret_access_key)
    export AWS_SESSION_TOKEN=$(echo $creds_json | jq -r .credentials.aws_session_token)
    export AWS_SECURITY_TOKEN=$(echo $creds_json | jq -r .credentials.aws_security_token)
}

writecreds() {
    echo "## Writing your credentials to [$PHYS_AWS_PROFILE] profile"
    aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID --profile $PHYS_AWS_PROFILE
    aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY --profile $PHYS_AWS_PROFILE
    aws configure set aws_session_token $AWS_SESSION_TOKEN --profile $PHYS_AWS_PROFILE
    aws configure set aws_security_token $AWS_SECURITY_TOKEN --profile $PHYS_AWS_PROFILE
}


goodmorning() {
    echo "## Good morning $USER"
    clearcreds
    getcreds
    writecreds
    bastionbg
}

bastionbg() {
    ssh -fN bastion
}

# for when you've opened a new shell but you still have valid creds
helloagain() {
    echo "## Hello again $USER"
    export AWS_ACCESS_KEY_ID=$(aws configure get aws_access_key_id --profile $PHYS_AWS_PROFILE)
    export AWS_SECRET_ACCESS_KEY=$(aws configure get aws_secret_access_key --profile $PHYS_AWS_PROFILE)
    export AWS_SESSION_TOKEN=$(aws configure get aws_session_token --profile $PHYS_AWS_PROFILE)
    export AWS_SECURITY_TOKEN=$(aws configure get aws_security_token --profile $PHYS_AWS_PROFILE)
}

# from coda guide
echo 'Dependencies for coda'
brew list autoenv || brew install autoenv
source "$(brew --prefix autoenv)/activate.sh"

command -v virtualenv || pip install virtualenv

