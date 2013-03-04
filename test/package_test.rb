require_relative 'test_helper'
require 'fileutils'
require 'rspec'

describe "overall test suite" do
  TRUNK_IMAGE = "TrunkImage"
  PACKAGE_TEST_IMAGE = "PackageTest"

def prepare_package_image(os_name)
  Dir.chdir(TARGET_DIR) {
    FileUtils.cp("#{TRUNK_IMAGE}.image", "#{PACKAGE_TEST_IMAGE}.image")
    FileUtils.cp("#{TRUNK_IMAGE}.changes", "#{PACKAGE_TEST_IMAGE}.changes")
  }
  run_image_with_cmd(os_name, PACKAGE_TEST_IMAGE, "prepare-test-image.st")
end


  def run_test(os_name, pkg_name)
    Dir.chdir(TARGET_DIR) {
      FileUtils.cp("#{PACKAGE_TEST_IMAGE}.image", "#{pkg_name}.image")
      FileUtils.cp("#{PACKAGE_TEST_IMAGE}.changes", "#{pkg_name}.changes")
    }
    run_image_with_cmd(os_name, pkg_name, "#{SRC}/package-load-tests/#{pkg_name}.st")
    Dir.chdir(TARGET_DIR) {
      FileUtils.rm("#{pkg_name}.image")
      FileUtils.rm("#{pkg_name}.changes")
    }
  end

  after :all do
    Dir.chdir(TARGET_DIR) {
      FileUtils.rm("PackageTest.image") if File.exists?("PackageTest.image")
      FileUtils.rm("PackageTest.changes") if File.exists?("PackageTest.changes")
    }
  end

  before :all do
    fetch_cog_vm(OS_NAME)
    fetch_interpreter_vm(OS_NAME)
    update_image()
    prepare_package_image(OS_NAME)
  end

  shared_examples "external package" do
    it "should pass all Control tests" do
      run_test(vm, 'Control')
    end

    it "should pass all Control tests" do
      run_test(vm, 'SqueakCheck')
    end
  end

  it_should_behave_like "external package" do
    let(:vm) { COG_VM }
  end

  # it_should_behave_like "external package" do
  #   let(:vm) { INTERPRETER_VM }
  # end
end

describe "Test suite for" do
  def run_test(vm_location, package_name)
    Dir.chdir('target') {
      FileUtils.cp('PackageTest.image', "#{package_name}.image")
      FileUtils.cp('PackageTest.changes', "#{package_name}.changes")
    }
    `#{vm_location} #{VM_ARGS} "package-load-tests/#{package_name}.st`
  end
end
