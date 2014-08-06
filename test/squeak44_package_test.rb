require_relative 'test_helper'
require_relative 'package_examples'
require 'fileutils'
require 'rspec'
require 'timeout'

describe "External package in" do
  context "Squeak 4.4" do
    before :all do
      @base_image_name = "Squeak4.4"
      assert_target_dir
      @os_name = identify_os
      @cog_vm = assert_cog_vm(@os_name)
      @cog_mtht_vm = assert_cogmtht_vm(@os_name)
      @interpreter_vm = assert_interpreter_vm(@os_name)
      FileUtils.cp("#{@base_image_name}.image", "#{TARGET_DIR}/#{@base_image_name}.image")
      FileUtils.cp("#{@base_image_name}.changes", "#{TARGET_DIR}/#{@base_image_name}.changes")
      prepare_package_image(@interpreter_vm, @os_name, @base_image_name, "update-squeak44-image.st")
    end

    it_behaves_like "external packages"
  end
end
