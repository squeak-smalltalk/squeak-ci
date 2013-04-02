require 'fileutils'
require 'squeak-ci/build'
require 'timeout'

def prepare_package_image(vm, os_name, base_image_name, update_script = nil)
  Dir.chdir(TARGET_DIR) {
    FileUtils.cp("#{base_image_name}.image", "#{PACKAGE_TEST_IMAGE}.image")
    FileUtils.cp("#{base_image_name}.changes", "#{PACKAGE_TEST_IMAGE}.changes")
  }
  run_image_with_cmd(vm, vm_args(os_name), PACKAGE_TEST_IMAGE, "#{SRC}/#{update_script}") if update_script
  run_image_with_cmd(vm, vm_args(os_name), PACKAGE_TEST_IMAGE, "#{SRC}/prepare-test-image.st")
end

def run_test(vm, os_name, pkg_name)
  begin
    Dir.chdir(TARGET_DIR) {
      FileUtils.cp("#{PACKAGE_TEST_IMAGE}.image", "#{pkg_name}.image")
      FileUtils.cp("#{PACKAGE_TEST_IMAGE}.changes", "#{pkg_name}.changes")
    }
    run_image_with_cmd(vm, vm_args(os_name), pkg_name, "#{SRC}/package-load-tests/#{pkg_name}.st")
  ensure
    Dir.chdir(TARGET_DIR) {
      FileUtils.rm("#{pkg_name}.image")
      FileUtils.rm("#{pkg_name}.changes")
    }
  end
end

def run_test_with_timeout(vm, os_name, package, timeout_secs)
  Timeout::timeout(timeout_secs) {
    run_test(vm, os_name, package)
  }.should_not raise_error Timeout::Error
end
