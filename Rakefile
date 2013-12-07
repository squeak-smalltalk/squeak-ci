require 'rubygems'
require 'rubygems/package_task'
require 'ci/reporter/rake/rspec'
require 'rake'
require 'rspec/core/rake_task'
require 'rake/clean'
require 'rake/testtask'
require 'pathname'
require 'zip'

require File.expand_path("#{File.expand_path(File.dirname(__FILE__))}/lib/squeak-ci/build")
require File.expand_path("#{File.expand_path(File.dirname(__FILE__))}/lib/squeak-ci/version")

CLEAN.include('target')

task :default => :test

task :build do
  TEST_IMAGE_NAME = "Squeak4.5"

  assert_target_dir
  os_name = identify_os
  cog_vm = assert_cog_vm(os_name)
  interpreter_vm = assert_interpreter_vm(os_name)
  puts "Cog VM at #{cog_vm}" if cog_vm
  puts "Interpreter VM at #{interpreter_vm}" if interpreter_vm
  raise "No VMs!" if !cog_vm && !interpreter_vm

  FileUtils.cp("#{TEST_IMAGE_NAME}.image", "#{SRC}/target/#{TRUNK_IMAGE}.image")
  FileUtils.cp("#{TEST_IMAGE_NAME}.changes", "#{SRC}/target/#{TRUNK_IMAGE}.changes")
  Dir.chdir(TARGET_DIR) {
    assert_interpreter_compatible_image(interpreter_vm, TRUNK_IMAGE, os_name)
  }
end

task :perf => :build do
  perf_image = "PerfTest"

  assert_target_dir
  os_name = identify_os
  cog_vm = assert_cog_vm(os_name)
  interpreter_vm = assert_interpreter_vm(os_name)
  puts "Cog VM at #{cog_vm}" if cog_vm
  puts "Interpreter VM at #{interpreter_vm}" if interpreter_vm
  raise "No VMs!" if !cog_vm && !interpreter_vm

  Dir.chdir(TARGET_DIR) {
    FileUtils.cp("#{TRUNK_IMAGE}.image", "#{perf_image}.image")
    FileUtils.cp("#{TRUNK_IMAGE}.changes", "#{perf_image}.changes")
    run_image_with_cmd((cog_vm || interpreter_vm), vm_args(os_name), perf_image, "#{SRC}/benchmarks.st")
  }
end

# Create a new base image by taking the target/TrunkImage image, updating it,
# and storing it in something like target/Squeak4.5.image. You can then update
# the repository's base image by copying the file into the repository's root
# image. THIS IS DELIBERATELY MANUAL.
task :update_base_image => :build do
  squeak_update_number = latest_downloaded_trunk_version(SRC)
  base_name = "#{SQUEAK_VERSION}"
  os_name = identify_os
  cog_vm = assert_cog_vm(os_name)
  interpreter_vm = assert_interpreter_vm(os_name)

  puts "Using #{interpreter_vm}"
  puts "Preparing to update image #{base_name}"
  FileUtils.cp("#{SRC}/target/#{TRUNK_IMAGE}.image", "#{SRC}/target/#{base_name}.image")
  FileUtils.cp("#{SRC}/target/#{TRUNK_IMAGE}.changes", "#{SRC}/target/#{base_name}.changes")

  Dir.chdir(TARGET_DIR) {
    run_image_with_cmd((cog_vm || interpreter_vm), vm_args(os_name), TRUNK_IMAGE, "#{SRC}/update-image.st", 25.minutes)
    assert_interpreter_compatible_image(interpreter_vm, TRUNK_IMAGE, os_name)
  }
end

task :release => :test do
  os_name = identify_os
  interpreter_vm = assert_interpreter_vm(os_name)
  squeak_update_number = image_version(interpreter_vm, vm_args(os_name), "#{SRC}/target/#{TRUNK_IMAGE}.image")
  base_name = "#{SQUEAK_VERSION}-#{squeak_update_number}"

  puts "Preparing to release image based on #{base_name}"
  FileUtils.cp("#{SRC}/target/#{TRUNK_IMAGE}.image", "#{SRC}/target/ReleaseCandidate.image")
  FileUtils.cp("#{SRC}/target/#{TRUNK_IMAGE}.changes", "#{SRC}/target/ReleaseCandidate.changes")

  FileUtils.chmod('+w', "#{SRC}/target/ReleaseCandidate.changes")
  FileUtils.chmod('+w', "#{SRC}/target/ReleaseCandidate.image")

  puts "Releasing based off #{base_name}"
  run_image_with_cmd(interpreter_vm, vm_args(os_name), 'ReleaseCandidate', "#{SRC}/release.st", 15.minutes)

  squeak_update_number = image_version(interpreter_vm, vm_args(os_name), "#{SRC}/target/ReleaseCandidate.image")
  release_name = "#{SQUEAK_VERSION}-#{squeak_update_number}"
  FileUtils.cp("#{SRC}/target/ReleaseCandidate.image", "#{SRC}/target/#{release_name}.image")
  FileUtils.cp("#{SRC}/target/ReleaseCandidate.changes", "#{SRC}/target/#{release_name}.changes")
  puts "Zipping #{release_name}"
  FileUtils.rm("#{SRC}/target/Squeak#{SQUEAK_VERSION}.zip") if File.exist?("#{SRC}/target/Squeak#{SQUEAK_VERSION}.zip")
  Zip::File.open("#{SRC}/target/Squeak#{SQUEAK_VERSION}.zip", Zip::File::CREATE) { |z|
    ['changes', 'image'].each { |suffix|
      z.add("#{release_name}.#{suffix}", "#{SRC}/target/#{release_name}.#{suffix}")
    }
  }
end

RSpec::Core::RakeTask.new(:test => :update_base_image) do |test|
  test.pattern = 'test/image_test.rb'
  test.verbose = true
end

RSpec::Core::RakeTask.new(:interpreter_test => :update_base_image) do |test|
  test.rspec_opts = '--tag interpreter'
  test.pattern = 'test/image_test.rb'
  test.verbose = true
end

RSpec::Core::RakeTask.new(:package_test => :update_base_image) do |test|
  test.pattern = 'test/package_test.rb'
  test.verbose = true
end

RSpec::Core::RakeTask.new(:bleeding_edge_test => :update_base_image) do |test|
  test.pattern = 'test/bleeding_edge_test.rb'
  test.verbose = true
end

def assert_interpreter_compatible_image(interpreter_vm, image_name, os_name)
  # Double parent because "parent" means "dir of"
  interpreter_vm_dir = Pathname.new(interpreter_vm).parent.parent.to_s
  ckformat = run_cmd("find #{interpreter_vm_dir} -name ckformat").split("\n").first

  if ckformat && File.exists?(ckformat) then
    format = run_cmd("#{ckformat} #{SRC}/target/#{image_name}.image")
    puts "Before format conversion: \"#{SRC}/target/#{image_name} image format #{format}"
  else
    puts "WARNING: no ckformat found"
  end

  if File.exists?(interpreter_vm) then
    run_image_with_cmd(interpreter_vm, vm_args(os_name), image_name, "#{SRC}/save-image.st")
  else
    puts "WARNING: #{interpreter_vm} not found, image not converted to format 6504"
  end

  if ckformat && File.exists?(ckformat) then
    format = run_cmd("#{ckformat} #{SRC}/target/#{image_name}.image")
    puts "After format conversion: \"#{SRC}/target/#{image_name}.image\" image format #{format}"
  end
end

def image_version(vm, vm_args, image_name)
  s = "#{vm} #{vm_args.join(" ")} \"#{image_name}\" #{as_relative_path(Pathname.new(SRC + "/image-version.st"))}"
  puts s
  `#{s}`.split("\n").last.to_i
end
