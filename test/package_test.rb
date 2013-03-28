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
      @interpreter_vm = assert_interpreter_vm(@os_name)
      FileUtils.cp("#{squeak43_image}.image", "#{TARGET_DIR}/#{squeak43_image}.image")
      FileUtils.cp("#{squeak43_image}.changes", "#{TARGET_DIR}/#{squeak43_image}.changes")
      prepare_package_image(@interpreter_vm, @os_name, squeak43_image, "update-squeak43-image.st")
    end

    it_should_behave_like "all"
  end

  context "Squeak 4.4" do
    before :all do
      squeak44_image = "Squeak4.4"
      assert_target_dir
      @os_name = identify_os
      @cog_vm = assert_cog_vm(@os_name)
      @interpreter_vm = assert_interpreter_vm(@os_name)
      FileUtils.cp("#{squeak44_image}.image", "#{TARGET_DIR}/#{squeak44_image}.image")
      FileUtils.cp("#{squeak44_image}.changes", "#{TARGET_DIR}/#{squeak44_image}.changes")
      prepare_package_image(@interpreter_vm, @os_name, squeak44_image, "update-squeak44-image.st")
    end

    it_should_behave_like "all"
  end

  context "Squeak 4.5" do
    before :all do
      assert_target_dir
      @os_name = identify_os
      @cog_vm = assert_cog_vm(@os_name)
      @interpreter_vm = assert_interpreter_vm(@os_name)
      update_image
      prepare_package_image(@interpreter_vm, @os_name, TRUNK_IMAGE)
    end

    it_should_behave_like "all"
  end
end
