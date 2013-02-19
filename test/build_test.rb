require 'rspec'

describe "overall test suite" do
  it "should pass all tests on a Cog VM" do
    `./builtastic.sh`
    $?.success?.should be_true
  end
end
