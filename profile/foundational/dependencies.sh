# let's do a dependency check for downstream tooling
# checks to add: 
# jq


# CHECK "autoenv" "brew list autoenv" "brew install autoenv"
CHECK() {
    local tool_name=$1
    local check_cmd=$2
    local install_cmd=$3

    if [[ $(eval "${check_cmd} 2>&1") ]]; then
        echo "## ${tool_name} is ready to go"
    else
        echo "## installing ${tool_name}"
        eval $install_cmd
    fi
}

# CHECK_MANUAL "docker" "command -v docker" "head to https://docs.docker.com/docker-for-mac/install/ and follow the instructions"
CHECK_MANUAL() {
    local tool_name=$1
    local check_cmd=$2
    local instructions=$3
}


# BASE DEPS

echo "## Performing dependency check"
command -v gimme-aws-creds >/dev/null 2>&1 || pip install --upgrade wheel gimme-aws-creds && asdf reshim python # TODO (not generic)
command -v gimme-aws-creds >/dev/null 2>&1 || echo "Failed to install gimme-aws-creds, possible problem with pip"




# from coda guide (these should be moved to scripts for eadch project)
command -v virtualenv >/dev/null 2>&1 || pip install virtualenv

# for mobile app
CHECK android-studio 'brew list android-studio' 'brew cask install android-studio'

echo "## Dependency check passed"
