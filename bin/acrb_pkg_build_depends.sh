if [ "$RUNNER_OS" == "Linux" ]; then
    2>&1 # on guthub the stderr can be delayed
    sudo apt update
    sudo apt upgrade
    sudo apt install cdbs libgmp-dev libmpfr-dev r-mathlib libplot-dev libncurses-dev libpq-dev libreadline-dev libgsl-dev
elif [ "$RUNNER_OS" == "macOS" ]; then
    2>&1 # on guthub the stderr can be delayed
    : # softwareupdate -i -a
elif [ "$RUNNER_OS" == "Windows" ]; then
    choco install libgmp-dev libmpfr-dev r-mathlib libplot-dev libncurses-dev libpq-dev libreadline-dev libgsl-dev
    vcpkg libgmp-dev libmpfr-dev r-mathlib libplot-dev libncurses-dev libpq-dev libreadline-dev libgsl-dev
else
    echo "$RUNNER_OS not supported"
    exit 1
fi