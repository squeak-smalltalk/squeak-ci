Basic CI scripts for Squeak.

* Take a trunk image, update it, run all tests.
* Take a 4.3 image, update it, run all tests.

`build_cog_vm.sh` builds the Cog VM for the local platform. It assumes that another process has dumped a copy of the latest published VM source to its directory.

`build_interpreter_vm.sh` builds an interpreter VM for the local platform from the latest published source.

`builtastic.sh` takes an early 4.4 beta image, updates it from trunk, and runs the full suite of SUnit tests on it. It produces Hudson/Jenkins compatible test reports. (`builtasticWin.sh` and `builtasticMac.sh` provide alternative build scripts for Windows and OS X machines.)

`release.sh` assumes that `builtastic.sh` has run, and produces a release candidate image called `SqueakM.N-KKKK.image`.

`resources\wallpaper.png` contains the official background for the current Squeak release.

`run-test.sh` runs the tests for individual packages against (a copy of) the latest published Trunk image. Look in the `package-load-tests` directory to see the currently supported packages. Run it thusly: `run-test.sh MyPackage`.

Next-gen tests
--------------

I've started reimplementing all the test suites in Rake. On Windows this assumes you're using [Cygwin](http://www.cygwin.com) and [pik](https://github.com/vertiginous/pik):

    # Install pik
    pik install ruby 1.9.3
    pik use 193
    rake