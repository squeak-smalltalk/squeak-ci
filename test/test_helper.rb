BASE_URL="http://build.squeak.org/"
COG_VERSION=2678
OS_NAME="linux"
SRC=File.expand_path("#{File.expand_path(File.dirname(__FILE__))}/..")
COG_VM="#{SRC}/target/cog.r#{COG_VERSION}/coglinux/bin/squeak"
TARGET_DIR = "#{SRC}/target"

def download_image(latest_update_str)
  # There's actually a race here, between time-of-check (getting the latest update)
  # and time-of-use (actually downloading the image)
  `curl -sSo "#{SRC}/target/#{TRUNK_IMAGE}.image" #{BASE_URL}/job/SqueakTrunk/lastSuccessfulBuild/artifact/target/#{TRUNK_IMAGE}.image`
  `curl -sSo "#{SRC}/target/#{TRUNK_IMAGE}.changes" #{BASE_URL}/job/SqueakTrunk/lastSuccessfulBuild/artifact/target/#{TRUNK_IMAGE}.changes`
end

def fetch_cog_vm(os_name)
  cog_dir = "#{SRC}/target/cog.r#{COG_VERSION}"
  FileUtils.mkdir_p(cog_dir)
  case os_name
  when "linux"
    Dir.chdir(cog_dir) {
      `curl -sSO http://www.mirandabanda.org/files/Cog/VM/VM.r#{COG_VERSION}/coglinux.tgz`
      `tar zxf coglinux.tgz`
    }
  when "freebsd"
    raise "Sadly, FreeBSD doesn't have prebuilt binaries for Cog yet"
  else
    raise "Unknown OS #{os_name} for Cog VM. Aborting."
  end
end

def fetch_interpreter_vm(os_name)
end

def run_image_with_cmd(os_name, image_name, cmd)
  `nice #{COG_VM} #{vm_args(os_name)} "#{SRC}/target/#{image_name}.image" #{cmd}`
end

def update_image
  current_update = if File.exist?('target/#{TRUNK_IMAGE}.version') then
                     `cat target/#{TRUNK_IMAGE}.version`.to_i
                   else
                     0
                   end
  latest_update = `curl -sS #{BASE_URL}/job/SqueakTrunk/lastSuccessfulBuild/artifact/target/#{TRUNK_IMAGE}.version`.to_i
  if current_update < latest_update then
    download_image(latest_update)
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
