require 'rubygems'
require 'rubygems/package_task'
require 'rake'
require 'rspec/core/rake_task'
require 'rake/clean'
require 'rake/testtask'

CLEAN.include('target')

task :test => :build do |test|
  test.pattern = 'test/*_test.rb'
  test.verbose = true
end

task :default => :test

task :build do
  require File.expand_path("#{File.expand_path(File.dirname(__FILE__))}/lib/squeak-ci/build")
  TEST_IMAGE_NAME = "Squeak4.4"

  assert_target_dir
  os_name = identify_os
  cog_vm = assert_cog_vm(os_name)
  interpreter_vm = assert_interpreter_vm(os_name)

  FileUtils.cp("#{TEST_IMAGE_NAME}.image", "#{SRC}/target/#{TRUNK_IMAGE}.image")
  FileUtils.cp("#{TEST_IMAGE_NAME}.changes", "#{SRC}/target/#{TRUNK_IMAGE}.changes")
  Dir.chdir(TARGET_DIR) {
    update_base_image(cog_vm, vm_args(os_name), TRUNK_IMAGE)
    ensure_interpreter_compatible_image(interpreter_vm, TRUNK_IMAGE, os_name)
  }
end

def update_base_image(vm, vm_args, image_name)
  run_image_with_cmd(vm, vm_args, image_name, "#{SRC}/update-image.st")
  version = run_cmd("cat #{SRC}/target/TrunkImage.version")
  puts "Updated to update number #{version}"
end

def ensure_interpreter_compatible_image(interpreter_vm, image_name, os_name)
  # Double parent because "parent" means "dir of"
  interpreter_vm_dir = Pathname.new(interpreter_vm).parent.parent.to_s
  ckformat = run_cmd("find #{interpreter_vm_dir} -name ckformat").split("\n").first

  if File.exists?(ckformat) then
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

  if File.exists?(ckformat) then
    format = run_cmd("#{ckformat} #{SRC}/target/#{image_name}.image")
    puts "After format conversion: \"#{SRC}/target/#{image_name}.image\" image format #{format}"
  end
end
