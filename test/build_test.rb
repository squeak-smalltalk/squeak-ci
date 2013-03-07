require_relative 'test_helper'
require 'fileutils'
require 'rspec'

describe "overall test suite" do
  before :all do
    assert_target_dir
    @cog_vm = assert_cog_vm(OS_NAME)
    @interpreter_vm = assert_interpreter_vm(OS_NAME)
    update_image()
  end

  it "should pass all tests on a Cog VM" do
#    `./builtastic.sh`
#    $?.success?.should be_true
  end
end
