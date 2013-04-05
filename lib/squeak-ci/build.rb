require 'zip/zip'
require_relative 'version'

BASE_URL="http://build.squeak.org/"
SRC=File.expand_path("#{File.expand_path(File.dirname(__FILE__))}/../..") # Oh, the horror!
COG_VM="#{SRC}/target/cog.r#{COG_VERSION}/coglinux/bin/squeak"
TARGET_DIR = "#{SRC}/target"
TRUNK_IMAGE="TrunkImage"

def as_relative_path(script_path)
  # Windows doesn't let you use a script with a full path, so we turn all script
  # references into relative paths.
  Pathname.new(script_path).relative_path_from(Pathname.new(TARGET_DIR)).to_s
end

def assert_coglike_vm(os_name, vm_type = :normal)
  cog_dir = "#{SRC}/target/#{cog_name(vm_type)}.r#{COG_VERSION}"

  cogs = Dir.glob("#{SRC}/target/#{cog_name(vm_type)}.r*")
  cogs.delete(File.expand_path(cog_dir))
  cogs.each { |stale_cog|
    log("Deleting stale #{cog_name(vm_type)} at #{stale_cog}")
    FileUtils.rm_rf(stale_cog)
  }
  if File.exists?(cog_dir) then
    log("Using existing #{cog_name(vm_type)} r.#{COG_VERSION}")
  else
    assert_target_dir
    log("Installing new #{cog_name(vm_type)} r.#{COG_VERSION}")
    FileUtils.mkdir_p(cog_dir)
    case os_name
    when "linux", "linux64"
      Dir.chdir(cog_dir) {
        run_cmd "curl -sSo #{cog_name(vm_type)}linux.tgz http://www.mirandabanda.org/files/Cog/VM/VM.r#{COG_VERSION}/#{cog_name(vm_type)}linux.tgz"
        run_cmd "tar zxf #{cog_name(vm_type)}linux.tgz"
      }
    when "freebsd"
      log("Sadly, FreeBSD doesn't have prebuilt binaries for Cog yet")
    when "windows"
      Dir.chdir(cog_dir) {
        run_cmd "curl -sSo #{cog_name(vm_type)}win.zip http://www.mirandabanda.org/files/Cog/VM/VM.r#{COG_VERSION}/#{cog_name(vm_type)}win.zip"
        Zip::ZipFile.open("#{cog_name(vm_type)}win.zip") { |z|
          z.each { |f|
            f_path = File.join(Dir.pwd, f.name)
            FileUtils.mkdir_p(File.dirname(f_path))
            z.extract(f, f_path) unless File.exist?(f_path)
          }
        }
      }
    else
      log("Unknown OS #{os_name} for Cog VM. Aborting.")
    end
  end

  return cog_location(os_name, vm_type)
end

def assert_cog_vm(os_name)
  return assert_coglike_vm(os_name)
end

def assert_interpreter_vm(os_name)
  # word_size is 32 or 64, for 32-bit or 64-bit.

  word_size = if (os_name == "linux64") then
                64
              else
                32
              end

  interpreter_src_dir = "#{SRC}/target/Squeak-#{INTERPRETER_VERSION}-src-#{word_size}"
  if File.exist?(interpreter_src_dir) then
    log("Using pre-existing interpreter VM in #{interpreter_src_dir}")
  else
    assert_target_dir
    case os_name
    when "linux", "linux64", "freebsd", "osx"
      log("Downloading Interpreter VM #{INTERPRETER_VERSION}")
      Dir.chdir(TARGET_DIR) {
        Dir.glob("*-src-*") {|stale_interpreter| FileUtils.rm_rf(stale_interpreter)}
        run_cmd("curl -sSo interpreter.tgz http://www.squeakvm.org/unix/release/Squeak-#{INTERPRETER_VERSION}-src.tar.gz")
        run_cmd("tar zxf interpreter.tgz")
        FileUtils.mv("Squeak-#{INTERPRETER_VERSION}-src", interpreter_src_dir)
        FileUtils.mkdir_p("#{interpreter_src_dir}/bld")
        Dir.chdir("#{interpreter_src_dir}/bld") {
          run_cmd("../unix/cmake/configure")
          run_cmd("make WIDTH=#{word_size}")
          assert_ssl("#{interpreter_src_dir}/bld", os_name)
        }
      }
    when "windows"
      log("Downloading Interpreter VM #{WINDOWS_INTERPRETER_VERSION}")
      interpreter_src_dir = "#{SRC}/target/Squeak-#{WINDOWS_INTERPRETER_VERSION}-src-#{word_size}"
      FileUtils.rm_rf(interpreter_src_dir) if File.exist?(interpreter_src_dir)
      Dir.chdir(TARGET_DIR) {
        run_cmd "curl -sSo interpreter.zip http://www.squeakvm.org/win32/release/Squeak#{WINDOWS_INTERPRETER_VERSION}.win32-i386.zip"
        Zip::ZipFile.open("interpreter.zip") { |z|
          z.each { |f|
            f_path = File.join(Dir.pwd, f.name)
            FileUtils.mkdir_p(File.dirname(f_path))
            z.extract(f, f_path) unless File.exist?(f_path)
          }
        }
        FileUtils.mv("Squeak#{WINDOWS_INTERPRETER_VERSION}", interpreter_src_dir)
      }
    else
      log("Unknown OS #{os_name} for Interpreter VM. Aborting.")
    end
  end
  interpreter_vm_location(os_name)
end

def assert_ssl(target_dir, os_name)
  # My hope is that this becomes a standard plugin, and this function can disappear.
  raise "Can't install SSL on #{os_name}" if not ["linux", "linux64"].include?(os_name)
  if not File.exist?("#{target_dir}/SqueakSSL") then
    Dir.chdir(target_dir) {
      run_cmd("curl -sSO https://squeakssl.googlecode.com/files/SqueakSSL-bin-0.1.5.zip")
      run_cmd("unzip SqueakSSL-bin-0.1.5.zip")
      FileUtils.mkdir_p("SqueakSSL")
      FileUtils.cp("SqueakSSL-bin/unix/so.SqueakSSL", "#{target_dir}/SqueakSSL/so.SqueakSSL")
      FileUtils.rm_rf("SqueakSSL-bin")
    }
  end
end

def assert_trunk_image
  if File.exists?("#{SRC}/target/TrunkImage.image") then
    log("Using existing TrunkImage")
  else
    log("Downloading new TrunkImage")
    Dir.chdir(TARGET_DIR) {
      run_cmd "curl -sSO #{BASE_URL}/job/SqueakTrunk/lastSuccessfulBuild/artifact/target/#{TRUNK_IMAGE}.image"
      run_cmd "curl -sSO #{BASE_URL}/job/SqueakTrunk/lastSuccessfulBuild/artifact/target/#{TRUNK_IMAGE}.changes"
    }
  end
end

def assert_target_dir
  FileUtils.mkdir_p(TARGET_DIR)
  ["SqueakV41.sources", "HudsonBuildTools.st"].each { |name|
    FileUtils.cp("#{SRC}/#{name}", "#{SRC}/target/#{name}") unless File.exists?("#{SRC}/target/#{name}")
  }
end

def cog_location(os_name, vm_type = :normal)
  base_name = cog_name(vm_type)
  case os_name
  when "linux", "linux64" then "#{SRC}/target/#{base_name}.r#{COG_VERSION}/#{base_name}linux/bin/squeak"
  when "windows" then "#{SRC}/target/#{base_name}.r#{COG_VERSION}/#{base_name}win/Croquet.exe"
  else
    nil
  end
end

def cog_name(vm_type)
  case vm_type
  when :normal then 'cog'
  when :mt then 'cogmt'
  else
    raise "Unknown vm_type #{vm_type.inspect} given to cog_name"
  end
end

def debug?
  ! ENV['DEBUG'].nil?
end

def identify_os
  return "windows" if (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM)

  str = `uname -a`
  return "linux" if str.include?("Linux") && ! str.include?("x86_64")
  return "linux64" if str.include?("Linux") && str.include?("x86_64")
  return "UNKNOWN"
end

def interpreter_vm_location(os_name)
  word_size = if (os_name == "linux64") then
                64
              else
                32
              end

  version = if os_name == "windows" then
              WINDOWS_INTERPRETER_VERSION
            else
              INTERPRETER_VERSION
            end

  interpreter_src_dir = "#{SRC}/target/Squeak-#{version}-src-#{word_size}"

  case os_name
  when "linux", "linux64", "freebsd", "osx" then "#{interpreter_src_dir}/bld/squeak.sh"
  when "windows" then "#{interpreter_src_dir}/Squeak#{version}.exe"
  else
    nil
  end
end

def run_image_with_cmd(vm_name, arr_of_vm_args, image_name, cmd)
  run_cmd "nice #{vm_name} #{arr_of_vm_args.join(" ")} \"#{SRC}/target/#{image_name}.image\" #{as_relative_path(Pathname.new(cmd))}"
end

def latest_downloaded_trunk_version
  if File.exist?('target/#{TRUNK_IMAGE}.version') then
    `cat target/#{TRUNK_IMAGE}.version`.to_i
  else
    0
  end
end

def log(str)
  puts str if debug?
end

def run_cmd(str)
  log(str)

  `#{str}`
end

def update_image
  # There's actually a race here, between time-of-check (getting the latest update)
  # and time-of-use (actually downloading the image)

  latest_released_update = `curl -sS #{BASE_URL}/job/SqueakTrunk/lastSuccessfulBuild/artifact/target/#{TRUNK_IMAGE}.version`.to_i
  if latest_downloaded_trunk_version < latest_released_update then
    assert_trunk_image
  end
end

def vm_args(os_name)
  return [] if debug?

  case os_name
  when "osx"
    ["-headless"]
  when "linux", "linux64", "freebsd"
    ["-vm-sound-null", "-vm-display-null"]
  when "windows"
    ["-headless"]
  else
    raise "Don't know what VM args to give for #{os_name}"
  end
end
