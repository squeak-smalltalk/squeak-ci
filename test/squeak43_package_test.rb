require_relative 'test_helper'
require_relative 'package_examples'
require 'fileutils'
require 'rspec'
require 'timeout'

describe "External package in" do
  context "Squeak 4.3" do
    before :all do
      squeak43_image = "Squeak4.3"
      assert_target_dir
      @os_name = identify_os
      @cog_vm = assert_cog_vm(@os_name)
      @cog_mt_vm = assert_cogmt_vm(@os_name)
      @interpreter_vm = assert_interpreter_vm(@os_name)
      FileUtils.cp("#{squeak43_image}.image", "#{TARGET_DIR}/#{squeak43_image}.image")
      FileUtils.cp("#{squeak43_image}.changes", "#{TARGET_DIR}/#{squeak43_image}.changes")
      prepare_package_image(@interpreter_vm, @os_name, squeak43_image, "update-squeak43-image.st")
    end

    it_should_behave_like "all"
  end
end
