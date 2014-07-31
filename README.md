Basic CI scripts for Squeak.

Requirements
------------

* ruby 1.9 (but 2.0 should work too)
* cmake
* gcc
* zip
* unzip
* curl

On Windows this assumes you're using [Cygwin](http://www.cygwin.com) and [pik](https://github.com/vertiginous/pik):

````shell
# Install pik
pik install ruby 1.9.3
pik use 193
````

On other OSes:

````shell
# Install RVM (or chruby, or rbenv, or...)
$ \curl -L https://get.rvm.io | bash -s stable --ruby=1.9.3
$ cd squeak-ci
$ which ruby
/home/frank/.rvm/rubies/ruby-1.9.3-p392/bin/ruby
````

After you have a Ruby installed, set up the initial environment:

````shell
$ gem install bundle # if necessary
$ bundle install
````

How do I contribute?
--------------------

Report bugs in the issue list, or on squeak-dev@lists.squeak.org. Ideally I'd like to see a pull request raised against the master branch, but if you've only got time to drop a mail or a note in the issue tracker, that's fine too.

Volunteering to run a build slave
---------------------------------

We are very happy to accept offers of build slaves! To run a build slave you'll need some additional software:

* Java (1.6 or later),
* git (1.7 or later),
* rvm

Ask on squeak-dev@lists.squeak.org, and you'll get a user account. Then
* add a new node, labelling it with either `32bit` or `64bit`, and the OS - `linux`, `windows`, `osx`, `freebsd`, and so on.
* `apt-get install openjdk-7-jdk cmake ruby1.9 zip unzip` or equivalent
* 64 bit Linux users will need to `apt-get install libc6:i386`
* `wget http://build.squeak.org/jnlpJars/slave.jar`
* `java -jar slave.jar -jnlpUrl http://build.squeak.org/computer/${SLAVENAME}/slave-agent.jnlp -jnlpCredentials username:password`

To keep your slave persistently connected, you could always write a small upstart or systemd script to run Java.

What does what?
---------------

`build_cog_vm.sh` builds the Cog VM for the local platform. It assumes that another process has dumped a copy of the latest published VM source to its directory.

`build_interpreter_vm.sh` builds an interpreter VM for the local platform from the latest published source.

`rake build` prepares a test environment.

`rake update_base_image` takes an early 4.5 alpha image and updates it from trunk. It's a minimal image. ("Minimal" is more a description of what it should be, rather than what it is.)

`rake test` does what `rake update_base_image` does, and runs the full suite of SUnit tests on it. It produces Hudson/Jenkins compatible test reports. It should run on Linux, OS X, and Windows machines. FreeBSD support will follow as soon as some issues are resolved.

`rake perf` runs the performance tests in `benchmarks.st`, to allow Hudson to measure overall performance of the 4.5 image as it evolves.

`rake release` produces a 4.5 image suitable for release, labelled `SqueakM.N-KKKK.image` in a zipfile called `Squeak4.5.zip`. In particular, it loads several well-known packages.

`resources\wallpaper.png` contains the official background for the current Squeak release.

To run the tests for a particular package (find the currently supported packages in the `package-load-tests` directory) like this: `rspec -fdoc --tag Xtreams test/package_test.rb`.

Additional reading
------------------

If you run into any issues, please raise an issue here. If it looks like the issue's not a build in the scripts but a problem in building the VM, please mail vm-dev@lists.squeak.org with details of your operating system and the output showing the problem.

While waiting for a reply, take a look the the [official VM guides](http://squeakvm.org/index.html) and see if you can solve the issue yourself. (If you do, please tell someone about it, either here as an issue, or in a post to the vm-dev list.)

Licence
-------

Copyright (C) 2012-2013 by Frank Shearar

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

Current status
--------------

[![Build Status](https://secure.travis-ci.org/frankshearar/squeak-ci.png?branch=master)](http://travis-ci.org/frankshearar/squeak-ci)
