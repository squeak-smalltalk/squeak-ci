require_relative 'test_helper'
require_relative 'package_examples'
require 'squeak-ci/test'
require 'fileutils'
require 'rspec'

describe "External package in" do
  context "Squeak 4.6" do
    before :all do
      @base_image_name = "Squeak4.6"
      assert_target_dir
      @os_name = identify_os
      @cog_vm = assert_cog_vm(@os_name)
      @cog_mt_vm = assert_cogmt_vm(@os_name)
      @interpreter_vm = assert_interpreter_vm(@os_name)
      FileUtils.cp("#{@base_image_name}.image", "#{TARGET_DIR}/#{@base_image_name}.image")
      FileUtils.cp("#{@base_image_name}.changes", "#{TARGET_DIR}/#{@base_image_name}.changes")
      prepare_package_image(@interpreter_vm, @os_name, @base_image_name, "update-image.st")
    end

    ['Fuel', 'Metacello'].each { |pkg_name|
      describe "#{pkg_name} (bleeding edge)", pkg_name.to_sym => true do
        let(:package) { "#{pkg_name}-head" }
        it_behaves_like "an external package"
      end
    }
  end
end
