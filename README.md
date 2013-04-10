Basic CI scripts for Squeak.

Requirements
------------

* ruby 1.9 (but 2.0 should work too)
* cmake
* gcc
* zip
* unzip

On Windows this assumes you're using [Cygwin](http://www.cygwin.com) and [pik](https://github.com/vertiginous/pik):

    # Install pik
    pik install ruby 1.9.3
    pik use 193
    rake

What does what?
---------------

`build_cog_vm.sh` builds the Cog VM for the local platform. It assumes that another process has dumped a copy of the latest published VM source to its directory.

`build_interpreter_vm.sh` builds an interpreter VM for the local platform from the latest published source.

`rake build` takes an early 4.5 beta image and updates it from trunk. It's a minimal image. ("Minimal" is more a description of what it should be, rather than what it is.)

`rake test` does what `rake build` does, and runs the full suite of SUnit tests on it. It produces Hudson/Jenkins compatible test reports. It should run on Linux, OS X, and Windows machines. FreeBSD support will follow as soon as some issues are resolved.

`rake perf` runs the performance tests in `benchmarks.st`, to allow Hudson to measure overall performance of the 4.5 image as it evolves.

`rake release` produces a 4.5 image suitable for release, labelled `SqueakM.N-KKKK.image`. In particular, it loads several well-known packages.

`resources\wallpaper.png` contains the official background for the current Squeak release.

`run-test.sh` runs the tests for individual packages against (a copy of) the latest published Trunk image. Look in the `package-load-tests` directory to see the currently supported packages. Run it thusly: `run-test.sh MyPackage`. (This script will probably fall away at some stage.)