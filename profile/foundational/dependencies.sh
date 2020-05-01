# let's do a dependency check for downstream tooling
# checks to add: 
# jq


echo "## Performing dependency check"

command -v gimme-aws-creds >/dev/null 2>&1 || pip install --upgrade wheel gimme-aws-creds && asdf reshim python # TODO (not generic)
command -v gimme-aws-creds >/dev/null 2>&1 || echo "Failed to install gimme-aws-creds, possible problem with pip"


# from coda guide
command -v virtualenv >/dev/null 2>&1 || pip install virtualenv
brew list autoenv >/dev/null 2>&1 || brew install autoenv
source "$(brew --prefix autoenv)/activate.sh"

echo "## Dependency check passed"