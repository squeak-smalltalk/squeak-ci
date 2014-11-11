require_relative 'test_helper'
require_relative 'package_examples'
require 'fileutils'
require 'rspec'
require 'timeout'

describe "External package in" do
  context "Squeak 4.6" do
    def prep_target(vm, base_image_name, image_name)
      if (vm) then
        Dir.chdir(TARGET_DIR) {
          FileUtils.cp("#{base_image_name}.image", "#{image_name}.image")
          FileUtils.cp("#{base_image_name}.changes", "#{image_name}.changes")
        }
        prepare_package_image(vm, @os_name, image_name)
      end
    end

    def cleanup_target(image_name)
      Dir.chdir(TARGET_DIR) {
        FileUtils.rm("#{image_name}.image") if File.exists?("#{image_name}.image")
        FileUtils.rm("#{image_name}.changes") if File.exists?("#{image_name}.changes")
      }
    end

    def preferably_cog_vm
      # Use Cog if it's there, but fall back to the Interpreter for non-Coggy platforms (like FreeBSD)
      @cog_vm || @interpreter_vm
    end

    before :all do
      assert_target_dir
      @base_image_name = TRUNK_IMAGE
      @os_name = identify_os
      @cog_vm = assert_cog_vm(@os_name)
      @cog_mtht_vm = assert_cogmtht_vm(@os_name)
      @cog_spur_vm = assert_cog_spur_vm(@os_name)
      @interpreter_vm = assert_interpreter_vm(@os_name)
    end

    before :all do
      prep_target(preferably_cog_vm, TRUNK_IMAGE, PACKAGE_TEST_IMAGE)
      prep_target(@cog_spur_vm, SPUR_TRUNK_IMAGE, SPUR_PACKAGE_TEST_IMAGE)
    end

    after :all do
      cleanup_target(PACKAGE_TEST_IMAGE)
      cleanup_target(SPUR_PACKAGE_TEST_IMAGE)
    end

    it_behaves_like "external packages"
  end
end
