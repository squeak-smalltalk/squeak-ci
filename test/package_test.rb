require_relative 'test_helper'
require 'fileutils'
require 'rspec'
require 'timeout'

describe "External package" do
  PACKAGE_TEST_IMAGE = "PackageTest"

  def prepare_package_image(os_name)
    Dir.chdir(TARGET_DIR) {
      FileUtils.cp("#{TRUNK_IMAGE}.image", "#{PACKAGE_TEST_IMAGE}.image")
      FileUtils.cp("#{TRUNK_IMAGE}.changes", "#{PACKAGE_TEST_IMAGE}.changes")
    }
    run_image_with_cmd(COG_VM, vm_args(os_name), PACKAGE_TEST_IMAGE, "#{SRC}/prepare-test-image.st")
  end

  def run_test(vm, os_name, pkg_name)
    Dir.chdir(TARGET_DIR) {
      FileUtils.cp("#{PACKAGE_TEST_IMAGE}.image", "#{pkg_name}.image")
      FileUtils.cp("#{PACKAGE_TEST_IMAGE}.changes", "#{pkg_name}.changes")
    }
    run_image_with_cmd(vm, vm_args(os_name), pkg_name, "#{SRC}/package-load-tests/#{pkg_name}.st")
    Dir.chdir(TARGET_DIR) {
      FileUtils.rm("#{pkg_name}.image")
      FileUtils.rm("#{pkg_name}.changes")
    }
  end

  def run_test_with_timeout(vm, os_name, package, timeout_secs)
    Timeout::timeout(timeout_secs) {
      run_test(vm, os_name, package)
    }.should_not raise_error Timeout::Error
  end

  after :all do
    Dir.chdir(TARGET_DIR) {
      FileUtils.rm("#{PACKAGE_TEST_IMAGE}.image") if File.exists?("#{PACKAGE_TEST_IMAGE}.image")
      FileUtils.rm("#{PACKAGE_TEST_IMAGE}.changes") if File.exists?("#{PACKAGE_TEST_IMAGE}.changes")
    }
  end

  before :all do
    assert_target_dir
    @os_name = identify_os
    @cog_vm = assert_cog_vm(@os_name)
    @interpreter_vm = assert_interpreter_vm(@os_name)
    update_image
    prepare_package_image(@os_name)
  end

  shared_examples "an external package" do
    context "should pass all tests" do
      it "on Cog" do
        run_test_with_timeout(@cog_vm, @os_name, package, 60)
      end

      it "on Interpreter" do
        run_test_with_timeout(@interpreter_vm, @os_name, package, 60)
      end
    end
  end

  describe "Control" do
    let(:package) { "Control" }
    it_behaves_like "an external package"
  end

  describe "FFI" do
    let(:package) { "FFI" }
    it_behaves_like "an external package"
  end

  # describe "Fuel" do
  #   let(:package) { "Fuel" }
  #   it_behaves_like "an external package"
  # end

  describe "Quaternion" do
    let(:package) { "Quaternion" }
    it_behaves_like "an external package"
  end

  describe "RoelTyper" do
    let(:package) { "RoelTyper" }
    it_behaves_like "an external package"
  end

  describe "SqueakCheck" do
    let(:package) { "SqueakCheck" }
    it_behaves_like "an external package"
  end

  describe "Xtreams" do
    let(:package) { "Xtreams" }
    it_behaves_like "an external package"
  end

  describe "Zippers" do
    let(:package) { "Zippers" }
    it_behaves_like "an external package"
  end
end
