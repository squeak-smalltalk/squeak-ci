require_relative 'test_helper'
require 'fileutils'
require 'rspec'

describe "External package" do
  PACKAGE_TEST_IMAGE = "PackageTest"

  def prepare_package_image(os_name)
    Dir.chdir(TARGET_DIR) {
      FileUtils.cp("#{TRUNK_IMAGE}.image", "#{PACKAGE_TEST_IMAGE}.image")
      FileUtils.cp("#{TRUNK_IMAGE}.changes", "#{PACKAGE_TEST_IMAGE}.changes")
    }
    run_image_with_cmd(COG_VM, os_name, PACKAGE_TEST_IMAGE, "#{SRC}/prepare-test-image.st")
  end

  def run_test(vm, pkg_name)
    Dir.chdir(TARGET_DIR) {
      FileUtils.cp("#{PACKAGE_TEST_IMAGE}.image", "#{pkg_name}.image")
      FileUtils.cp("#{PACKAGE_TEST_IMAGE}.changes", "#{pkg_name}.changes")
    }
    run_image_with_cmd(vm, OS_NAME, pkg_name, "#{SRC}/package-load-tests/#{pkg_name}.st")
    Dir.chdir(TARGET_DIR) {
      FileUtils.rm("#{pkg_name}.image")
      FileUtils.rm("#{pkg_name}.changes")
    }
  end

  after :all do
    Dir.chdir(TARGET_DIR) {
      FileUtils.rm("#{PACKAGE_TEST_IMAGE}.image") if File.exists?("#{PACKAGE_TEST_IMAGE}.image")
      FileUtils.rm("#{PACKAGE_TEST_IMAGE}.changes") if File.exists?("#{PACKAGE_TEST_IMAGE}.changes")
    }
  end

  before :all do
    assert_target_dir
    assert_cog_vm(OS_NAME)
    assert_interpreter_vm(OS_NAME)
    update_image()
    prepare_package_image(OS_NAME)
  end

  shared_examples "an external package" do
    context "should pass all tests" do
      it "on Cog" do
        puts package.inspect
        run_test(COG_VM, package)
      end

    # it "on Interpreter" do
    #   run_test(INTERPRETER_VM, 'SqueakCheck')
    # end
    end
  end

  describe "SqueakCheck" do
    let(:package) { "SqueakCheck" }
    it_behaves_like "an external package"
  end
end
