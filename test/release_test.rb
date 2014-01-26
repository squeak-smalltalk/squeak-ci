require_relative 'test_helper'
require 'fileutils'
require 'rspec'

# This test suite assumes that there's a Squeak4.5.zip file in target/, and that
# this zipfile contains files named Squeak4.5-NNNN.image and
# Squeak4.5-NNNN.changes.
describe "Release test suite" do
  RUN_TEST_IMAGE_NAME = "ReleaseCandidateTest"

  before :all do
    Dir.chdir(TARGET_DIR) {

      # Copy the clean image so we can run the tests without touching the artifact.
      unzip('Squeak4.5.zip')
      log("Unzipping:")
      Dir.glob('Squeak4.5-*.*') { |release_file|
        extension = Pathname.new(release_file).extname
        dest = "#{SRC}/target/#{RUN_TEST_IMAGE_NAME}#{extension}"
        log("Moving #{release_file} to #{dest}")
        FileUtils.cp(release_file, dest)
      }
    }
  end

  after :all do
    ["#{RUN_TEST_IMAGE_NAME}.image", "#{RUN_TEST_IMAGE_NAME}.changes"].each { |f|
      FileUtils.rm(f) if File.exists?(f)
    }
  end

  context "image test suite" do
    it "should pass all tests on Interpreter VM", :interpreter => true do
      Dir.chdir(TARGET_DIR) {
        os_name = identify_os
        vm = assert_interpreter_vm(os_name)
        log("VM: #{vm}")
        args = vm_args(os_name)
        run_image_with_cmd(vm, vm_args(os_name), RUN_TEST_IMAGE_NAME, "#{SRC}/tests.st", 20.minutes)
      }
    end
  end
end
