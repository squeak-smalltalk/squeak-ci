require 'zip'
require_relative 'extensions'
require_relative 'version'
require_relative 'utils'

BASE_URL="http://build.squeak.org/"
SRC=File.expand_path("#{File.expand_path(File.dirname(__FILE__))}/../..") # Oh, the horror!
TARGET_DIR = "#{SRC}/target"
TRUNK_IMAGE="TrunkImage"
SPUR_TRUNK_IMAGE="SpurTrunkImage"

FU = FileUtils::Verbose
#FU = FileUtils


module CommandCount
  extend self
  @@COMMAND_COUNT = 0
  def step
    r = @@COMMAND_COUNT
    @@COMMAND_COUNT += 1
    r
  end
end
def counted_command
  yield(CommandCount.step)
end

class UnknownOS < Exception
  def initialize(os_name)
    @os_name = os_name
    super "Unknown OS #{os_name}"
  end

  attr_accessor :os_name
end

def as_relative_path(script_path)
  # Windows doesn't let you use a script with a full path, so we turn all script
  # references into relative paths.
  Pathname.new(script_path).relative_path_from(Pathname.new(TARGET_DIR)).to_s
end

def temp_exec_location(src)
  # The laucher scripts do not handle well spaces in their path
  # so we use a temporary location (that typically has no spaces)
  tmp_exec_dir = Dir.mktmpdir
  at_exit { FileUtils.remove_entry_secure tmp_exec_dir }
  FU.cp_r(src, tmp_exec_dir)
  ret = yield(Pathname.new(tmp_exec_dir))
  ret
end

# vm_type element_of [:mt, :mtht, :normal, :spur]
def assert_coglike_vm(os_name, vm_type)
  cog = COG_VERSION.dir_name(os_name, vm_type)
  cog_desc = "#{cog} r.#{COG_VERSION.svnid}"

  cog_dir = "#{TARGET_DIR}/#{cog}.r#{COG_VERSION.svnid}"

  cogs = Dir.glob("#{TARGET_DIR}/#{cog}.r*")
  cogs.delete(File.expand_path(cog_dir))
  cogs.each { |stale_cog|
    log("Deleting stale #{cog} at #{stale_cog}")
    FU.rm_rf(stale_cog)
  }
  if File.exists?(cog_dir) then
    log("Using existing #{cog_desc}")
    temp_exec_location(cog_dir) do | tmp_exec_dir |
      COG_VERSION.cog_location(tmp_exec_dir, os_name, vm_type)
    end
  else
    assert_target_dir
    log("Installing new #{cog_desc} (#{vm_type})")
    FU.mkdir_p(cog_dir)
    begin
      begin
        download_cog(os_name, vm_type, COG_VERSION, cog_dir)
        plugin_dir = COG_VERSION.lib_dir("#{TARGET_DIR}/", os_name, vm_type)
        assert_ssl(plugin_dir, os_name)
        temp_exec_location(cog_dir) do | tmp_exec_dir |
          COG_VERSION.cog_location(tmp_exec_dir, os_name, vm_type)
        end
      rescue UnknownOS => e
        log("Unknown OS #{e.os_name} for Cog VM. Aborting.")
        raise e
      end
    rescue => e
      FU.rm_rf(cog_dir)
      log("Cleaning up failed install of #{cog_desc} (#{e.message})")
      nil
    end
  end
end

def assert_cog_vm(os_name)
  # This is not easy to ensure on slaves.
  # return case os_name
  #        when "linux", "linux64" then assert_coglike_vm(os_name, :ht)
  #        else assert_coglike_vm(os_name, :normal)
  #        end
  assert_coglike_vm(os_name, :normal)
end

def assert_cogmt_vm(os_name)
  return assert_coglike_vm(os_name, :mt)
end

def assert_cogmtht_vm(os_name)
  return assert_coglike_vm(os_name, :mtht)
end

def assert_cog_spur_vm(os_name)
  return assert_coglike_vm(os_name, :spur)
end

def assert_interpreter_compatible_image(interpreter_vm, image_name, os_name)

  interpreter_format = "6504"

  # Double parent because "parent" means "dir of"
  interpreter_vm_dir = Pathname.new(interpreter_vm).parent.parent.to_s
  ckformat = nil
  # Gag at the using-side-effects nonsense.
  Pathname.new(interpreter_vm_dir).find {|path| ckformat = path if path.basename.to_s == 'ckformat'}

  if ckformat then
    format = run_cmd(%("#{ckformat}" "#{TARGET_DIR}/#{image_name}.image"))
    puts "Before format conversion: \"#{TARGET_DIR}/#{image_name} image format #{format}"

    # if format == interpreter_format
    #   puts "nothing to be done"
    #   return
    # end
  else
    puts "WARNING: no ckformat found"
  end

  if File.exists?(interpreter_vm) then
    # Attempted workaround to address the different args used by the different VMs.
    args = if os_name == "osx" then ["-vm-display-null"] else vm_args(os_name) end
    run_image_with_cmd(interpreter_vm, args, image_name, "#{SRC}/save-image.st")
  else
    puts "WARNING: #{interpreter_vm} not found, image not converted to format #{interpreter_format}"
  end

  if ckformat then
    image_location = "#{TARGET_DIR}/#{image_name}.image"
    format = run_cmd(%("#{ckformat}" "#{image_location}"))
    puts "After format conversion: \"#{image_location}\" image format #{format}"
  end
end

def assert_interpreter_vm(os_name)
  # word_size is 32 or 64, for 32-bit or 64-bit.
  word_size = if (os_name == "linux64") then
                64
              else
                32
              end

  src_dir_name="Squeak-#{INTERPRETER_VERSION}-src"
  interpreter_src_dir = "#{TARGET_DIR}/#{src_dir_name}-#{word_size}"

  if File.exist?(interpreter_vm_location(interpreter_src_dir, os_name)) then
    log("Using existing interpreter VM in #{interpreter_src_dir}")
  else
    assert_target_dir
    case os_name
    when "linux", "linux64", "freebsd"
      raise "Missing Cmake. Please install it!" unless run_cmd "cmake"
      log("Downloading Interpreter VM #{INTERPRETER_VERSION}")
      Dir.chdir(TARGET_DIR) { Dir.glob("*-src-*") {|stale_interpreter| FU.rm_rf(stale_interpreter)} }
      Dir.mktmpdir do | tmpdir |
        Dir.chdir(tmpdir) {
          run_cmd(%(curl -LsSo interpreter.tgz http://www.squeakvm.org/unix/release/Squeak-#{INTERPRETER_VERSION}-src.tar.gz))
          run_cmd(%(tar zxf interpreter.tgz))
          build_dir = "#{src_dir_name}/bld"
          FU.mkdir_p(build_dir)
          Dir.chdir(build_dir) {
            run_cmd(%(../unix/cmake/configure))
            run_cmd(%(make WIDTH=#{word_size}))
            assert_ssl(Dir.pwd, os_name)
          }
          FU.mv(src_dir_name, interpreter_src_dir)
        }
      end
    when "windows"
      log("Downloading Interpreter VM #{WINDOWS_INTERPRETER_VERSION}")
      interpreter_src_dir = "#{TARGET_DIR}/Squeak-#{WINDOWS_INTERPRETER_VERSION}-src-#{word_size}"
      FU.rm_rf(interpreter_src_dir) if File.exist?(interpreter_src_dir)
      Dir.chdir(TARGET_DIR) {
        run_cmd(%(curl -LsSo interpreter.zip "http://www.squeakvm.org/win32/release/Squeak#{WINDOWS_INTERPRETER_VERSION}.win32-i386.zip"))
        unzip('interpreter.zip')
        FU.mv("Squeak#{WINDOWS_INTERPRETER_VERSION}", interpreter_src_dir)
      }
    when "osx"
      log("Downloading Interpreter VM #{MAC_INTERPRETER_VERSION}")
      Dir.chdir(TARGET_DIR) {
        run_cmd(%(curl -LsSo interpreter.zip "http://www.squeakvm.org/mac/release/Squeak%20#{MAC_INTERPRETER_VERSION}.zip"))
        unzip('interpreter.zip')
        FU.mv("Squeak #{MAC_INTERPRETER_VERSION}.app", interpreter_dir)
      }
    else
      log("Unknown OS #{os_name} for Interpreter VM. Aborting.")
    end
  end
  temp_exec_location(interpreter_src_dir + "/.") do | tmp_exec_dir |
    interpreter_vm_location(tmp_exec_dir, os_name)
  end
end

def assert_ssl(target_dir, os_name)
  res_url = "https://github.com/itsmeront/squeakssl/releases/download/#{SQUEAK_SSL_RELEASE}"
  case os_name
  when "linux", "linux64"
    run_cmd(%(curl -LsSO "#{res_url}/linux32.zip"))
    unzip('linux32.zip')
    FU.cp('linux32/SqueakSSL', target_dir)
  when 'windows'
    run_cmd(%(curl -LsSO "#{res_url}/windows.zip"))
    unzip('windows.zip')
    FU.cp('windows/SqueakSSL.DLL', "#{}/SqueakSSL.dll")
  when 'osx'
    run_cmd(%(curl -LsSO "#{res_url}/macosx.zip"))
    unzip('macosx.zip')
    FU.cp_r('macosx/SqueakSSL.bundle', target_dir)
  else
    raise "Can't install SSL on #{os_name} yet"
  end
end

def assert_trunk_image
  if File.exists?("#{TARGET_DIR}/#{TRUNK_IMAGE}.image") then
    log("Using existing #{TRUNK_IMAGE}")
  else
    log("Downloading new #{TRUNK_IMAGE}")
    Dir.chdir(TARGET_DIR) {
      run_cmd(%(curl -LsSO "#{BASE_URL}/job/SqueakTrunk/lastSuccessfulBuild/artifact/target/#{TRUNK_IMAGE}.image"))
      run_cmd(%(curl -LsSO "#{BASE_URL}/job/SqueakTrunk/lastSuccessfulBuild/artifact/target/#{TRUNK_IMAGE}.changes"))
    }
  end
end

def assert_target_dir
  FU.mkdir_p(TARGET_DIR)
  FU.cp(Dir.chdir(SRC) { Dir["*.sources"]} + ["HudsonBuildTools.st"], TARGET_DIR)
end

def cog_archive_name(os_name, vm_type, cog_version)
  suffix, ext = case os_name
                when "freebsd"
                  ["fbsd", "tgz"]
                when "linux", "linux64"
                  ["linux", "tgz"]
                when "osx"
                  ["osx", "tgz"]
                when "windows"
                  ["win", "zip"]
                else
                  raise UnknownOS.new(os_name)
                end
  "#{cog_version.dir_name(os_name, vm_type)}#{suffix}.#{ext}"
end

def debug?
  # For the nonce, always output debug info
  true
#  ! ENV['DEBUG'].nil?
end

def download_cog(os_name, vm_type, cog_version, cog_dir)
  local_name = cog_archive_name(os_name, vm_type, cog_version)
  download_url = "http://www.mirandabanda.org/files/Cog/VM/VM.r#{cog_version.svnid}/#{cog_version.filename(os_name, vm_type)}"
  Dir.chdir(cog_dir) {
    run_cmd(%(curl -LsSo "#{local_name}" "#{download_url}"))

    case os_name
    when "windows"
      unzip(local_name)
    else
      run_cmd(%(tar zxf "#{local_name}"))
    end
  }
end

def identify_os
  return "windows" if (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM)

  str = `uname -a`
  return "linux" if str.include?("Linux") && ! str.include?("x86_64")
  return "linux64" if str.include?("Linux") && str.include?("x86_64")
  return "osx" if str.include?("Darwin")
  return "UNKNOWN"
end

def interpreter_vm_location(src_dir, os_name)
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

  case os_name
  when "linux", "linux64", "freebsd" then "#{src_dir}/bld/squeak.sh"
  when "windows" then "#{src_dir}/Squeak#{version}.exe"
  when "osx" then "#{src_dir}/Contents/MacOS/Squeak VM Opt"
  else
    nil
  end
end

# timeout in seconds
def run_image_with_cmd(vm_name, arr_of_vm_args, image_name, cmd, timeout = 600)
  log(cmd)
  vm_args_string = arr_of_vm_args.collect {|a| %("#{a}")}.join(" ")
  base_cmd = %("#{vm_name}" #{vm_args_string} "#{TARGET_DIR}/#{image_name}.image" "#{as_relative_path(Pathname.new(cmd))}")
  case identify_os
    when "windows" then begin
                          log(base_cmd)
                          system(base_cmd)
                        end
  else
    if identify_os == "osx" then base_cmd = "unset DISPLAY && #{base_cmd}" end

    counted_command do | cmd_count |
      log("spawning command #{cmd_count} with timeout #{timeout.to_s} seconds: #{base_cmd}")
      # Don't nice(1), because then the PID we get it nice's PID, not the Squeak process'
      # PID. We need this so we can send the process a USR1.
      pid = spawn(%(#{base_cmd} && echo command #{cmd_count} finished))
      log("(Command started with PID #{pid})")
      Thread.new {
        kill_time = Time.now + timeout.seconds
        process_gone = false
        while (Time.now < kill_time)
          sleep(1.second)
          begin
            Process.kill(0, pid)
          rescue Errno::ESRCH
            # The process is gone
            process_gone = true
            break
          end
        end

        if ! process_gone then
          log("!!! Killing command #{cmd_count} for exceeding allotted time: #{base_cmd}.")
          # Dump out debug info from the image before we kill it. Don't use Process.kill
          # because we want to capture stdout.
          output = run_cmd(%(kill -USR1 #{pid}))
          puts output
          puts "-------------"
#        output = run_cmd(%(pstree #{pid}))
#        $stdout.puts output
          begin
            Process.kill('KILL', pid)
          rescue Errno::ESRCH => e
              puts "Tried to kill process #{pid} but it's gone"
              raise e
          end
          puts "-------------"
          log("!!! Killed command #{cmd_count}")
          raise "Command #{cmd_count} killed: timed out."
        end
      }
      Process.wait(pid)
      raise "Process #{pid} failed with exit status #{$?.exitstatus}" if $?.exitstatus != 0
    end
  end
end

def latest_downloaded_trunk_version(base_path)
  if File.exist?('#{base_path}/target/#{TRUNK_IMAGE}.version') then
    v = File.read('#{base_path}/target/#{TRUNK_IMAGE}.version', 'r') { |f| f.read }
    v.to_i
  else
    0
  end
end

def unzip(file_name)
  Zip::File.open(file_name) { |z|
    z.each { |f|
      f_path = File.join(Dir.pwd, f.name)
      FU.mkdir_p(File.dirname(f_path))
      z.extract(f, f_path) unless File.exist?(f_path)
    }
  }
end

def vm_args(os_name)
  case os_name
  when "osx"
    ["-headless"]
  when "linux", "linux64", "freebsd"
    ["-vm-sound-null", "-vm-display-null"]
  when "windows"
    ["-headless"]
  else
    raise UnknownOS.new(os_name)
  end
end
