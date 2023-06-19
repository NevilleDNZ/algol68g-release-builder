if [ "$RUNNER_OS" == "Linux" ] || true; then
    2>&1 # on guthub the stderr can be delayed
    eval `date +"Y=%Y m=%m d=%d"`
    y=`expr $Y - 2000`
    case $m in 
        (01) m=0;; # make Jan/Feb the zeroth month.
        (02) m=0 d=`expr $d + 50`;; # append Feb to Jan
        (12) m=9 d=`expr $d + 50`;; # append Dec to Nov
        (*)  m=`expr $m - 2`;; # ... Sep, Oct, Nov are now ... 7, 8, 9
    esac
    . /etc/os-release
    os_release=$ID$VERSION_ID
    Build=$y$m$d
elif [ "$RUNNER_OS" == "macOS" ]; then
    2>&1 # on guthub the stderr can be delayed
    eval `date +"Y=%Y m=%m d=%d"`
    y=`expr $Y - 2000`
    case $m in 
        (01) m=0;; # make Jan/Feb the zeroth month.
        (02) m=0 d=`expr $d + 50`;; # append Feb to Jan
        (12) m=9 d=`expr $d + 50`;; # append Dec to Nov
        (*)  m=`expr $m - 2`;; # ... Sep, Oct, Nov are now ... 7, 8, 9
    esac
    os_release=$RUNNER_OS
    Build=$y$m$d
elif [ "$RUNNER_OS" == "Windows" ]; then
    os_release=$RUNNER_OS
    Build=$y$m$d
else
    echo "$RUNNER_OS not supported" 1>&2
    exit 1
fi
eval `sed "/^PACKAGE_VERSION=/!d; s/  *//g;" < configure | head -1` 
[ ! -n "$PACKAGE_VERSION" ] && PACKAGE_VERSION=3.99.99

echo "$PACKAGE_VERSION-$Build-$os_release"