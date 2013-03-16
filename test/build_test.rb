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

  it "should pass all tests" do
    Dir.chdir("#{SRC}/target") {
      run_cmd("#{@vm} -version")
      run_image_with_cmd(@vm, vm_args(@os_name) + ["-reportheadroom"], RUN_TEST_IMAGE_NAME, "#{SRC}/tests.st")
      run_image_with_cmd(@vm, vm_args(@os_name), RUN_TEST_IMAGE_NAME, "#{SRC}/benchmarks.st")
    }
  end
end
