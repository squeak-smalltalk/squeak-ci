Basic CI scripts for Squeak.

Requirements
------------

* ruby 1.9 (but 2.0 should work too)
* cmake
* gcc
* zip
* unzip

On Windows this assumes you're using [Cygwin](http://www.cygwin.com) and [pik](https://github.com/vertiginous/pik):

````shell
# Install pik
pik install ruby 1.9.3
pik use 193
````

On other OSes:

````shell
# Install RVM
$ \curl -L https://get.rvm.io | bash -s stable --ruby=1.9.3
$ cd squeak-ci
$ which ruby
/home/frank/.rvm/rubies/ruby-1.9.3-p392/bin/ruby
````

After you have a Ruby installed, set up the initial environment:

````ruby
gem install bundle # if necessary
bundle install
````

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

Licence
-------

Copyright (C) 2012-2013 by Frank Shearar

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

Current status
--------------

[![Build Status](https://secure.travis-ci.org/frankshearar/squeak-ci.png?branch=master)](http://travis-ci.org/frankshearar/squeak-ci)