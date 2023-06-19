# algol68g-release-builder
Using the NevilleDNZ/algol68g-mirror repo, build a release for `ubuntu-latest`.

Action plan: 

  - checkout `NevilleDNZ/algol68g-mirror/trunk` source code.
       - indivually install build-dependancies for a `full` build.
  - run: `autoconf_release_builder.py`
      - run `./configure` with `full` options
      - parse `config.log`
      - generate platform specific install builder:
        - `debian/*` for ubuntu-latest
        - `.spec` for rhel-latest/fedora-latest ✠
        - `.pkg` for macos-latest/unix ✠         
  - Then, build & test installer of the full binary for each platform matrix:
    - ubuntu-latest: `dpkg-buildpackage -rfakeroot -uc -b`
    - rhel-latest: `rpmbuild -bb --with full --without tiny --build-in-place algol68g-*.spec` ✠
    - macos-latest: `pkgbuild --install-location /Applications --component application-path ./Desktop/installer.pkg` ✠
    - windows-latest: [AliceOh/CreateWindowsInstaller@1.0.0](https://github.com/marketplace/actions/build-windows-installer-msi-from-exe-file) ? ✠
    - trigger AWS CodePipeline builds for other platforms ✠
    - Cantidate architectures:
      - x86_64/amd64, i686✠, i386✠
      - armv6, armv7, aarch64, riscv64, s390x, & ppc64le; ✠

  - Then, sign<sup>✠</sup> and deploy each of the binary & src package installers to standard upstream repos:
    - `.deb` for debian-latest
    - `.pkg` for macos-latest ✠
    - `.msi` for windows-latest ✠
    - `.rpm` for rhel-latest/fedora-latest ✠
  
(✠) - yet to do!