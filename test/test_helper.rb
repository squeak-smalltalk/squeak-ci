BASE_URL="http://build.squeak.org/"
COG_VERSION=2697
OS_NAME="linux"
SRC=File.expand_path("#{File.expand_path(File.dirname(__FILE__))}/..")
COG_VM="#{SRC}/target/cog.r#{COG_VERSION}/coglinux/bin/squeak"
TARGET_DIR = "#{SRC}/target"
TRUNK_IMAGE="TrunkImage"

def debug?
  ! ENV['DEBUG'].nil?
end

def log(str)
  puts str if debug?
end

def run_cmd(str)
  log(str)

  `#{str}`
end

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
    log("Installing new Cog r.#{COG_VERSION}")
    FileUtils.mkdir_p(cog_dir)
    case os_name
    when "linux"
      Dir.chdir(cog_dir) {
        run_cmd "curl -sSO http://www.mirandabanda.org/files/Cog/VM/VM.r#{COG_VERSION}/coglinux.tgz"
        run_cmd "tar zxf coglinux.tgz"
      }
    when "freebsd"
      raise "Sadly, FreeBSD doesn't have prebuilt binaries for Cog yet"
    else
      raise "Unknown OS #{os_name} for Cog VM. Aborting."
    end
  end
end

def assert_interpreter_vm(os_name)
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
  FileUtils.mkdir_p(TARGET_DIR) unless File.exists?(TARGET_DIR)
  ["SqueakV41.sources", "HudsonBuildTools.st"].each { |name|
    FileUtils.cp(name, "#{SRC}/#{name}") unless File.exists?("#{SRC}/#{name}")
  }
end

def run_image_with_cmd(vm, os_name, image_name, cmd)
  run_cmd "nice #{vm} #{vm_args(os_name)} \"#{SRC}/target/#{image_name}.image\" #{cmd}"
end

def latest_downloaded_trunk_version
  if File.exist?('target/#{TRUNK_IMAGE}.version') then
    `cat target/#{TRUNK_IMAGE}.version`.to_i
  else
    0
  end
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
  case os_name
  when "osx"
    "-headless"
  else
    "-vm-sound-null -vm-display-null"
  end
end
