BASE_URL="http://build.squeak.org/"
COG_VERSION=2701
INTERPRETER_VERSION="Squeak-4.10.2.2614"
SRC=File.expand_path("#{File.expand_path(File.dirname(__FILE__))}/../..") # Oh, the horror!
COG_VM="#{SRC}/target/cog.r#{COG_VERSION}/coglinux/bin/squeak"
TARGET_DIR = "#{SRC}/target"
TRUNK_IMAGE="TrunkImage"

def assert_cog_vm(os_name)
  cog_dir = "#{SRC}/target/cog.r#{COG_VERSION}"

  cogs = Dir.glob("#{SRC}/target/cog.r*")
  cogs.delete(File.expand_path(cog_dir))
  cogs.each { |stale_cog|
    log("Deleting stale Cog at #{stale_cog}")
    FileUtils.rm_rf(stale_cog)
  }

  if File.exists?(cog_dir) then
    log("Using existing Cog r.#{COG_VERSION}")
  else
    assert_target_dir
    log("Installing new Cog r.#{COG_VERSION}")
    FileUtils.mkdir_p(cog_dir)
    case os_name
    when "linux"
      Dir.chdir(cog_dir) {
        run_cmd "curl -sSO http://www.mirandabanda.org/files/Cog/VM/VM.r#{COG_VERSION}/coglinux.tgz"
        run_cmd "tar zxf coglinux.tgz"
      }
    when "freebsd"
      log("Sadly, FreeBSD doesn't have prebuilt binaries for Cog yet")
      return nil
    else
      log("Unknown OS #{os_name} for Cog VM. Aborting.")
      return nil
    end
  end

  return "#{SRC}/target/cog.r#{COG_VERSION}/coglinux/bin/squeak"
end

def assert_interpreter_vm(os_name)
  # word_size is 32 or 64, for 32-bit or 64-bit.

  word_size = if (os_name == "linux64") then
                64
              else
                32
              end

  interpreter_src_dir = "#{SRC}/target/#{INTERPRETER_VERSION}-src-#{word_size}"
  if File.exist?(interpreter_src_dir) then
    log("Using pre-existing interpreter VM in #{interpreter_src_dir}")
  else
    log("Downloading Interpreter VM #{INTERPRETER_VERSION}")
    assert_target_dir
    case os_name
    when "linux", "linux64", "freebsd", "osx"
      Dir.chdir(TARGET_DIR) {
        Dir.glob("*-src-*") {|stale_interpreter| FileUtils.rm_rf(stale_interpreter)}
        run_cmd("curl -sSo interpreter.tgz http://www.squeakvm.org/unix/release/#{INTERPRETER_VERSION}-src.tar.gz")
        run_cmd("tar zxf interpreter.tgz")
        FileUtils.mv("#{INTERPRETER_VERSION}-src", interpreter_src_dir)
        FileUtils.mkdir_p("#{interpreter_src_dir}/bld")

        Dir.chdir("#{interpreter_src_dir}/bld") {
          run_cmd("../unix/cmake/configure")
          run_cmd("make WIDTH=#{word_size}")
        }
      }
    else
      log("Unknown OS #{os_name} for Interpreter VM. Aborting.")
      return nil
    end
  end

  return "#{interpreter_src_dir}/bld/squeakvm"
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
    FileUtils.cp(name, "#{SRC}/target/#{name}") unless File.exists?("#{SRC}/target/#{name}")
  }
end

def debug?
  ! ENV['DEBUG'].nil?
end

def identify_os
  str = `uname -a`
  return "linux" if str.include?("Linux") && ! str.include?("x86_64")
  return "linux64" if str.include?("Linux") && str.include?("x86_64")
end

def run_image_with_cmd(vm_name, arr_of_vm_args, image_name, cmd)
  run_cmd "nice #{vm_name} #{arr_of_vm_args.join(" ")} \"#{SRC}/target/#{image_name}.image\" #{cmd}"
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
  else
    raise "Don't know what VM args to give for #{os_name}"
  end
end
