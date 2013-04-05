require 'squeak-ci/test'

PACKAGE_TEST_IMAGE = "PackageTest"

shared_examples "external package" do
  after :each do
    Dir.chdir(TARGET_DIR) {
      FileUtils.rm("#{package}.image") if File.exists?("#{package}.image")
      FileUtils.rm("#{package}.changes") if File.exists?("#{package}.changes")
    }
  end

  context "should pass all tests" do
    it "on Cog" do
      pending "Can't run Cog on this platform (#{identify_os})" if @cog_vm.to_s == ""
      run_test_with_timeout(@cog_vm, @os_name, package, 240)
    end

    it "on Cog MT" do
      pending "Can't run Cog MT on this platform (#{identify_os})" if @cog_mt_vm.to_s == ""
      run_test_with_timeout(@cog_mt_vm, @os_name, package, 240)
    end

    it "on Interpreter" do
      run_test_with_timeout(@interpreter_vm, @os_name, package, 240)
    end
  end
end

shared_examples "all" do
  describe "AndreasSystemProfiler" do
    let(:package) { "AndreasSystemProfiler" }
    it_behaves_like "external package"
  end

  describe "Control" do
    let(:package) { "Control" }
    it_behaves_like "external package"
  end

  describe "FFI" do
    let(:package) { "FFI" }
    it_behaves_like "external package"
  end

  describe "Fuel" do
    let(:package) { "Fuel" }
    it_behaves_like "external package"
  end

  describe "Metacello" do
    let(:package) { "Metacello" }
    it_behaves_like "external package"
  end

  describe "Nebraska" do
    let(:package) { "Nebraska" }
    it_behaves_like "external package"
  end

  describe "Nutcracker" do
    let(:package) { "Nutcracker" }
    it_behaves_like "external package"
  end

  describe "OSProcess" do
    let(:package) { "OSProcess" }
    it_behaves_like "external package"
  end

  describe "Quaternion" do
    let(:package) { "Quaternion" }
    it_behaves_like "external package"
  end

  describe "Phexample" do
    let(:package) { "Phexample" }
    it_behaves_like "external package"
  end

  describe "RoelTyper" do
    let(:package) { "RoelTyper" }
    it_behaves_like "external package"
  end

  describe "SqueakCheck" do
    let(:package) { "SqueakCheck" }
    it_behaves_like "external package"
  end

  describe "Universes" do
    let(:package) { "Universes" }
    it_behaves_like "external package"
  end

  describe "WebClient" do
    let(:package) { "WebClient" }
    it_behaves_like "external package"
  end

  describe "XML-Parser" do
    let(:package) { "XML-Parser" }
    it_behaves_like "external package"
  end

  describe "Xtreams" do
    let(:package) { "Xtreams" }
    it_behaves_like "external package"
  end

  describe "Zippers" do
    let(:package) { "Zippers" }
    it_behaves_like "external package"
  end
end
