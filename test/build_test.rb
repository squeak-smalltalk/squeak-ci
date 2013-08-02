require_relative 'test_helper'
require 'pathname'
require 'rspec'
require 'squeak-ci/build'

describe "Build.rb utility functions" do
  describe :as_relative_path do
    it "should relativize an absolute path" do
      known_script = Pathname.new("#{SRC}/thing.txt")
      # ".." because this test executes in the target/ directory.
      as_relative_path(known_script).should == "../thing.txt"
    end
  end
end
