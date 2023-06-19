Build=$1 os_release=$2 PACKAGE_VERSION=$3 artifact_dir=$4
echo Build=$1 os_release=$2 PACKAGE_VERSION=$3 artifact_dir=$4
2>&1 # on guthub the stderr can be delayed

if [ "$RUNNER_OS" == "Linux" ]; then
    REL=$PACKAGE_VERSION TAR="$REL-$Build" RBLD="$REL-$Build-$os_release" RBARCH="$RBLD"_*
    echo REL=$REL TAR=$tar RBLD=$RBLD RBARCH=$RBARCH
    set -x
    
  # RHEL
    # rpmbuild -bb --with full --without tiny --build-in-place algol68g-3.1.9-23221.spec
    # https://stackoverflow.com/questions/11903688/error-trying-to-sign-rpm
    # rpm --define "_gpg_name NevilleD.algol68@sgr-a.net" --addsign  /home/nevilled/rpmbuild/SRPMS/algol68g-3.2.0-23456_rhel_9.2.src.rpm /home/nevilled/rpmbuild/RPMS/x86_64/algol68g-full-3.2.0-23456_rhel_9.2.x86_64.rpm


  # Ubuntu/Debian
    # dpkg-buildpackage -rfakeroot --build=source --sign-key=NevilleD.algol68@sgr-a.net
    # dpkg-buildpackage -rfakeroot --build=any,all --sign-key=NevilleD.algol68@sgr-a.net
    
  # https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1015077
    aclocal && automake && autoconf && ./configure # needs to be before tarball - i.e. "error: aborting due to unexpected upstream changes"
    tar -czf ../algol68g_$TAR.orig.tar.gz * # IF debian || ubuntu...
    cp -p ../algol68g_$TAR.orig.tar.gz $artifact_dir 
    
    # https://askubuntu.com/questions/226495/how-to-solve-dpkg-source-source-problem-when-building-a-package
    dpkg-buildpackage --root-command=fakeroot --build=source --sign-key=NevilleD.algol68@sgr-a.net
    cp -p ../algol68g_$RBLD.dsc $artifact_dir || exit $? 
    cp -p ../algol68g_""$RBARCH.{buildinfo,changes} $artifact_dir

    dpkg-buildpackage --root-command=fakeroot --build=any,all --sign-key=NevilleD.algol68@sgr-a.net
    cp -p ../algol68g_$RBARCH.deb ../algol68g-dbgsym_$RBARCH.ddeb $artifact_dir || exit $?
    ./a68g -V

elif [ "$RUNNER_OS" == "macOS" ]; then
    : # softwareupdate -i -a

elif [ "$RUNNER_OS" == "Windows" ]; then
    choco install libgmp-dev libmpfr-dev r-mathlib libplot-dev libncurses-dev libpq-dev libreadline-dev libgsl-dev
    vcpkg libgmp-dev libmpfr-dev r-mathlib libplot-dev libncurses-dev libpq-dev libreadline-dev libgsl-dev

else
    echo "$RUNNER_OS not supported"
    exit 1
fi