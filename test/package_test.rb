require_relative 'test_helper'
require_relative 'package_examples'
require 'fileutils'
require 'rspec'
require 'timeout'

describe "External package in" do
  context "Squeak 4.6" do
    def preferably_cog_vm
      # Use Cog if it's there, but fall back to the Interpreter for non-Coggy platforms (like FreeBSD)
      @cog_vm || @interpreter_vm
    end

    before :all do
      @base_image_name = TRUNK_IMAGE
      assert_target_dir
      @os_name = identify_os
      @cog_vm = assert_cog_vm(@os_name)
      @cog_mtht_vm = assert_cogmtht_vm(@os_name)
      @cog_spur_vm = assert_cog_spur_vm(@os_name)
      @interpreter_vm = assert_interpreter_vm(@os_name)
      Dir.chdir(TARGET_DIR) {
        FileUtils.cp("#{TRUNK_IMAGE}.image", "#{PACKAGE_TEST_IMAGE}.image")
        FileUtils.cp("#{TRUNK_IMAGE}.changes", "#{PACKAGE_TEST_IMAGE}.changes")
      }
      prepare_package_image(preferably_cog_vm, @os_name, PACKAGE_TEST_IMAGE)
    end

    after :all do
      Dir.chdir(TARGET_DIR) {
        puts "after all an external package"
        FileUtils.rm("#{PACKAGE_TEST_IMAGE}.image") if File.exists?("#{PACKAGE_TEST_IMAGE}.image")
        FileUtils.rm("#{PACKAGE_TEST_IMAGE}.changes") if File.exists?("#{PACKAGE_TEST_IMAGE}.changes")
      }
    end

    it_behaves_like "external packages"
  end
end
