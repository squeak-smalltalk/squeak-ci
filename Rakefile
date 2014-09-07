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

# Take the base CI image and move it into a (possibly newly) prepared test
# environment in the target/ directory.
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
  puts "=== BUILD FINISHED"
end

task :spur_build do
  assert_target_dir
  os_name = identify_os
  cog_vm = assert_cog_spur_vm(os_name)
  puts "Cog VM at #{cog_vm}" if cog_vm
  raise "No VMs!" if !cog_vm

  run_cmd("curl -sSo #{SRC}/target/#{TRUNK_IMAGE}.image http://www.mirandabanda.org/files/Cog/VM/SpurImages/trunk46-spur.image")
  run_cmd("curl -sSo #{SRC}/target/#{TRUNK_IMAGE}.changes http://www.mirandabanda.org/files/Cog/VM/SpurImages/trunk46-spur.changes")

  puts "=== BUILD FINISHED"
end

# Run performance tests on the prepared TrunkImage (regardless of which step
# produced the current test environment).
task :perf => :build do
  perf_image = "PerfTest"

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
  puts "=== PERF FINISHED"
end

# Take the prepared TrunkImage image and update it.
task :update_base_image => :build do
  squeak_update_number = latest_downloaded_trunk_version(SRC)
  base_name = "#{SQUEAK_VERSION}"
  os_name = identify_os
  cog_vm = assert_cog_vm(os_name)
  interpreter_vm = assert_interpreter_vm(os_name)

  puts "Using #{interpreter_vm}"
  puts "Preparing to update image of #{base_name} vintage"

  squeak_update_number = Dir.chdir(TARGET_DIR) {
    run_image_with_cmd((cog_vm || interpreter_vm), vm_args(os_name), TRUNK_IMAGE, "#{SRC}/update-image.st", 25.minutes)
    assert_interpreter_compatible_image(interpreter_vm, TRUNK_IMAGE, os_name)

    FileUtils.rm("TrunkImage.zip") if File.exist?("TrunkImage.zip")
    Zip::File.open("TrunkImage.zip", Zip::File::CREATE) { |z|
      ['changes', 'image', 'manifest', 'version'].each { |suffix|
        z.add("TrunkImage.#{suffix}", "TrunkImage.#{suffix}")
      }
    }
    image_version(interpreter_vm, vm_args(os_name), "TrunkImage.image")
  }

  puts "Updated to #{SQUEAK_VERSION}-#{squeak_update_number}"

  puts "=== UPDATE_BASE_IMAGE FINISHED"
end

task :spur_update_base_image => :spur_build do
  squeak_update_number = latest_downloaded_trunk_version(SRC)
  base_name = "#{SQUEAK_VERSION}"
  os_name = identify_os
  cog_vm = assert_cog_spur_vm(os_name)

  puts "Preparing to update image of #{base_name} vintage"

  squeak_update_number = Dir.chdir(TARGET_DIR) {
    run_image_with_cmd(cog_vm, vm_args(os_name), TRUNK_IMAGE, "#{SRC}/update-image.st", 25.minutes)

    FileUtils.rm("TrunkImage.zip") if File.exist?("TrunkImage.zip")
    Zip::File.open("TrunkImage.zip", Zip::File::CREATE) { |z|
      ['changes', 'image', 'manifest', 'version'].each { |suffix|
        z.add("TrunkImage.#{suffix}", "TrunkImage.#{suffix}")
      }
    }
    image_version(cog_vm, vm_args(os_name), "TrunkImage.image")
  }

  puts "Updated to #{SQUEAK_VERSION}-#{squeak_update_number}"

  puts "=== UPDATE_BASE_IMAGE FINISHED"
end

# Take the target/TrunkImage image, run the release process on it, and store it
# in something like target/Squeak4.5.image.
task :release => :build do
  os_name = identify_os
  interpreter_vm = assert_interpreter_vm(os_name)
  cog_vm = assert_cog_vm(os_name)
  fail "Cannot release off #{os_name} OS" unless cog_vm

  squeak_update_number = image_version(interpreter_vm, vm_args(os_name), "#{SRC}/target/#{TRUNK_IMAGE}.image")
  base_name = "#{SQUEAK_VERSION}-#{squeak_update_number}"

  puts "Preparing to release image based on #{base_name} (TrunkImage.version says #{File.read("#{SRC}/target/#{TRUNK_IMAGE}.version")})"
  FileUtils.cp("#{SRC}/target/#{TRUNK_IMAGE}.image", "#{SRC}/target/ReleaseCandidate.image")
  FileUtils.cp("#{SRC}/target/#{TRUNK_IMAGE}.changes", "#{SRC}/target/ReleaseCandidate.changes")

  puts "Releasing based off #{base_name}"
  run_image_with_cmd(cog_vm, vm_args(os_name), 'ReleaseCandidate', "#{SRC}/release.st", 15.minutes)
  assert_interpreter_compatible_image(interpreter_vm, 'ReleaseCandidate', os_name)

  squeak_update_number = image_version(interpreter_vm, vm_args(os_name), "#{SRC}/target/ReleaseCandidate.image")
  release_name = "#{SQUEAK_VERSION}-#{squeak_update_number}"
  FileUtils.cp("#{SRC}/target/ReleaseCandidate.image", "#{SRC}/target/#{release_name}.image")
  FileUtils.cp("#{SRC}/target/ReleaseCandidate.changes", "#{SRC}/target/#{release_name}.changes")
  puts "Zipping #{release_name}"
  FileUtils.rm("#{SRC}/target/#{SQUEAK_VERSION}.zip") if File.exist?("#{SRC}/target/#{SQUEAK_VERSION}.zip")
  Zip::File.open("#{SRC}/target/#{SQUEAK_VERSION}.zip", Zip::File::CREATE) { |z|
    ['changes', 'image'].each { |suffix|
      z.add("#{release_name}.#{suffix}", "#{SRC}/target/#{release_name}.#{suffix}")
    }
  }
  puts "=== RELEASE FINISHED"
end

# Take the TrunkImage, release it, and test it.
RSpec::Core::RakeTask.new(:release_and_test => :release) do |test|
  test.pattern = 'test/release_test.rb'
  test.verbose = true
end

RSpec::Core::RakeTask.new(:test => :build) do |test|
  test.rspec_opts = '-fdoc --tag ~interpreter'
  test.pattern = 'test/image_test.rb'
  test.verbose = true
end

# The rest of the targets don't need to tell us when they're finished, because
# they're not links in the main build pipeline.
RSpec::Core::RakeTask.new(:interpreter_test => :build) do |test|
  test.rspec_opts = '-fdoc --tag interpreter'
  test.pattern = 'test/image_test.rb'
  test.verbose = true
end

RSpec::Core::RakeTask.new(:spur_test => :spur_build) do |test|
  test.rspec_opts = '-fdoc'
  test.pattern = 'test/spur_image_test.rb'
  test.verbose = true
end

RSpec::Core::RakeTask.new(:package_test => :build) do |test|
  test.rspec_opts = '-fdoc'
  test.pattern = 'test/package_test.rb'
  test.verbose = true
end

RSpec::Core::RakeTask.new(:bleeding_edge_test => :build) do |test|
  test.pattern = 'test/bleeding_edge_test.rb'
  test.verbose = true
end

def assert_interpreter_compatible_image(interpreter_vm, image_name, os_name)
  # Double parent because "parent" means "dir of"
  interpreter_vm_dir = Pathname.new(interpreter_vm).parent.parent.to_s
  ckformat = nil
  # Gag at the using-side-effects nonsense.
  Pathname.new(SRC).find {|path| ckformat = path if path.basename.to_s == 'ckformat'}

  if ckformat then
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

  if ckformat then
    format = run_cmd("#{ckformat} #{SRC}/target/#{image_name}.image")
    puts "After format conversion: \"#{SRC}/target/#{image_name}.image\" image format #{format}"
  end
end

def image_version(vm, vm_args, image_name)
  s = "#{vm} #{vm_args.join(" ")} \"#{image_name}\" #{as_relative_path(Pathname.new(SRC + "/image-version.st"))}"
  puts s
  `#{s}`.split("\n").last.to_i
end
