Basic CI scripts for Squeak.

* Take a trunk image, update it, run all tests.
* Take a 4.3 image, update it, run all tests.

`build_interpreter_vm.sh` builds an interpreter VM for the local platform.

`builtastic.sh` takes an early 4.4 beta image, updates it from trunk, and runs the full suite of SUnit tests on it. It produces Hudson/Jenkins compatible test reports. (`builtasticWin.sh` and `builtasticMac.sh` provide alternative build scripts for Windows and OS X machines.)

`release.sh` assumes that `builtastic.sh` has run, and produces a release candidate image called `SqueakM.N-KKKK.image`.

`resources\wallpaper.png` contains the official background for the current Squeak release.