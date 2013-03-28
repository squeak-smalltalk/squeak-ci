PACKAGE_TEST_IMAGE = "PackageTest"

def prepare_package_image(vm, os_name, base_image_name, update_script = nil)
  Dir.chdir(TARGET_DIR) {
    FileUtils.cp("#{base_image_name}.image", "#{PACKAGE_TEST_IMAGE}.image")
    FileUtils.cp("#{base_image_name}.changes", "#{PACKAGE_TEST_IMAGE}.changes")
  }
  run_image_with_cmd(vm, vm_args(os_name), PACKAGE_TEST_IMAGE, "#{SRC}/#{update_script}") if update_script
  run_image_with_cmd(vm, vm_args(os_name), PACKAGE_TEST_IMAGE, "#{SRC}/prepare-test-image.st")
end

def run_test(vm, os_name, pkg_name)
  begin
    Dir.chdir(TARGET_DIR) {
      FileUtils.cp("#{PACKAGE_TEST_IMAGE}.image", "#{pkg_name}.image")
      FileUtils.cp("#{PACKAGE_TEST_IMAGE}.changes", "#{pkg_name}.changes")
    }
    run_image_with_cmd(vm, vm_args(os_name), pkg_name, "#{SRC}/package-load-tests/#{pkg_name}.st")
  ensure
    Dir.chdir(TARGET_DIR) {
      FileUtils.rm("#{pkg_name}.image")
      FileUtils.rm("#{pkg_name}.changes")
    }
  end
end

def run_test_with_timeout(vm, os_name, package, timeout_secs)
  Timeout::timeout(timeout_secs) {
    run_test(vm, os_name, package)
  }.should_not raise_error Timeout::Error
end

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

  # describe "Control" do
  #   let(:package) { "Control" }
  #   it_behaves_like "external package"
  # end

  # describe "FFI" do
  #   let(:package) { "FFI" }
  #   it_behaves_like "external package"
  # end

  # # describe "Fuel" do
  # #   let(:package) { "Fuel" }
  # #   it_behaves_like "external package"
  # # end

  # describe "Nebraska" do
  #   let(:package) { "Nebraska" }
  #   it_behaves_like "external package"
  # end

  # describe "Nutcracker" do
  #   let(:package) { "Nutcracker" }
  #   it_behaves_like "external package"
  # end

  # describe "OSProcess" do
  #   let(:package) { "OSProcess" }
  #   it_behaves_like "external package"
  # end

  # describe "Quaternion" do
  #   let(:package) { "Quaternion" }
  #   it_behaves_like "external package"
  # end

  # describe "Phexample" do
  #   let(:package) { "Phexample" }
  #   it_behaves_like "external package"
  # end

  # describe "RoelTyper" do
  #   let(:package) { "RoelTyper" }
  #   it_behaves_like "external package"
  # end

  # describe "SqueakCheck" do
  #   let(:package) { "SqueakCheck" }
  #   it_behaves_like "external package"
  # end

  # describe "Universes" do
  #   let(:package) { "Universes" }
  #   it_behaves_like "external package"
  # end

  # describe "WebClient" do
  #   let(:package) { "WebClient" }
  #   it_behaves_like "external package"
  # end

  # describe "XML-Parser" do
  #   let(:package) { "XML-Parser" }
  #   it_behaves_like "external package"
  # end

  # describe "Xtreams" do
  #   let(:package) { "Xtreams" }
  #   it_behaves_like "external package"
  # end

  # describe "Zippers" do
  #   let(:package) { "Zippers" }
  #   it_behaves_like "external package"
  # end
end
