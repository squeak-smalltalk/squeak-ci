require_relative 'test_helper'
require 'fileutils'
require 'rspec'

describe "Trunk test suite" do
  RUN_TEST_IMAGE_NAME = "PostTestTrunkImage"

  before :all do
    @os_name = identify_os
    @vm = case @os_name
          when "linux64"
            assert_interpreter_vm(@os_name)
          when "osx" # Temporary: I just haven't figured out how to unpack/use the Cog on OS X.
            assert_interpreter_vm(@os_name)
          else
            assert_cog_vm(@os_name)
          end
    Dir.chdir(TARGET_DIR) {
      # Copy the clean image so we can run the tests without touching the artifact.
      FileUtils.cp("#{TRUNK_IMAGE}.image", "#{SRC}/target/#{RUN_TEST_IMAGE_NAME}.image")
      FileUtils.cp("#{TRUNK_IMAGE}.changes", "#{SRC}/target/#{RUN_TEST_IMAGE_NAME}.changes")
    }
  end

  after :all do
    ["#{RUN_TEST_IMAGE_NAME}.image", "#{RUN_TEST_IMAGE_NAME}.changes"].each { |f|
      FileUtils.rm(f) if File.exists?(f)
    }
  end

  context "image test suite" do
    it "should pass all tests" do
      Dir.chdir("#{SRC}/target") {
        log("VM: #{@vm}")
        run_cmd("#{@vm} -version")
        args = vm_args(@os_name)
        args << "-reportheadroom" unless @os_name == "linux64"
        run_image_with_cmd(@vm, vm_args(@os_name), RUN_TEST_IMAGE_NAME, "#{SRC}/tests.st", 20.minutes)
        run_image_with_cmd(@vm, vm_args(@os_name), RUN_TEST_IMAGE_NAME, "#{SRC}/benchmarks.st", 10.minutes)
      }
    end

    it "should pass all tests on Interpreter VM", :interpreter => true do
      Dir.chdir("#{SRC}/target") {
        vm = assert_interpreter_vm(@os_name)
        log("VM: #{vm}")
        run_cmd("#{vm} -version")
        args = vm_args(@os_name)
        args << "-reportheadroom" unless @os_name == "linux64"
        run_image_with_cmd(vm, vm_args(@os_name), RUN_TEST_IMAGE_NAME, "#{SRC}/tests.st", 30.minutes)
        run_image_with_cmd(@vm, vm_args(@os_name), RUN_TEST_IMAGE_NAME, "#{SRC}/benchmarks.st", 10.minutes)
      }
    end
  end
end
