require 'fileutils'
require 'rspec'

COG_VERSION=2678
SRC=File.expand_path("#{File.expand_path(File.dirname(__FILE__))}/..")
COG_VM="#{SRC}/target/cog.r#{COG_VERSION}/coglinux/bin/squeak"
OS_NAME="linux"

def vm_args(os_name)
  case os_name
  when "osx"
    "-headless"
  else
    "-vm-sound-null -vm-display-null"
  end
end

def fetch_cog_vm(os_name)
  if File.exists?(COG_VM) then
    puts "Using pre-existing Cog VM at #{COG_VM}"
  else
    puts "Downloading Cog VM r#{COG_VERSION}"
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
end

def run_image_with_cmd(os_name, image_name, cmd)
  `nice #{COG_VM} #{vm_args(os_name)} "#{SRC}/target/#{image_name}.image" #{cmd}`
end

def run_test(os_name, pkg_name)
  target_dir = "#{SRC}/target"
  FileUtils.mkdir_p(target_dir)
  FileUtils.cp("prepare-test-image.st", "#{target_dir}/prepare-test-image.st")
  Dir.chdir(target_dir) {
    FileUtils.cp("TrunkImage.image", "#{pkg_name}.image")
    FileUtils.cp("TrunkImage.changes", "#{pkg_name}.changes")
  }
  run_image_with_cmd(os_name, pkg_name, "prepare-test-image.st")
  run_image_with_cmd(os_name, pkg_name, "#{SRC}/package-load-tests/#{pkg_name}.st")
  Dir.chdir(target_dir) {
    FileUtils.rm("#{pkg_name}.image")
    FileUtils.rm("#{pkg_name}.changes")
  }
end

describe "overall test suite" do
  before :all do
    fetch_cog_vm(OS_NAME)
  end

  it "should pass all SqueakCheck tests" do
    run_test(OS_NAME, "SqueakCheck")
  end

  it "should pass all tests on a Cog VM" do
    `./builtastic.sh`
    $?.success?.should be_true
  end
end
