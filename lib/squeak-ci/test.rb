require 'fileutils'
require 'squeak-ci/build'
require 'timeout'

PACKAGE_TEST_IMAGE = "PackageTest"

def prepare_package_image(vm, os_name, base_image_name, update_script = nil)
  run_image_with_cmd(vm, vm_args(os_name), PACKAGE_TEST_IMAGE, "#{SRC}/#{update_script}") if update_script
  run_image_with_cmd(vm, vm_args(os_name), PACKAGE_TEST_IMAGE, "#{SRC}/prepare-test-image.st")
end

def run_test(vm, os_name, image_name, pkg_name)
  run_image_with_cmd(vm, vm_args(os_name), image_name, "#{SRC}/package-load-tests/#{pkg_name}.st")
end

def run_test_with_timeout(vm, os_name, image_name, package, timeout_secs)
  Timeout::timeout(timeout_secs) {
    run_test(vm, os_name, image_name, package)
  }.should_not raise_error Timeout::Error
end

def with_copy(image_name, disambiguation_marker, &block)
  copy_name = "#{image_name}-#{disambiguation_marker}"
  Dir.chdir(TARGET_DIR) {
    FileUtils.cp("#{image_name}.image", "#{copy_name}.image")
    FileUtils.cp("#{image_name}.changes", "#{image_name}-#{disambiguation_marker}.changes")
  }
  begin
    block.call(copy_name)
  ensure
    Dir.chdir(TARGET_DIR) {
      FileUtils.rm("#{copy_name}.image") if File.exists?("#{copy_name}.image")
      FileUtils.rm("#{image_name}-#{disambiguation_marker}.changes") if File.exists?("#{image_name}-#{disambiguation_marker}.changes")
    }
  end
end
