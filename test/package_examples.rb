require 'squeak-ci/test'

TEST_TIMEOUT = 600

shared_examples "an external package" do
  before :all do
    Dir.chdir(TARGET_DIR) {
      FileUtils.cp("#{@base_image_name}.image", "#{PACKAGE_TEST_IMAGE}.image")
      FileUtils.cp("#{@base_image_name}.changes", "#{PACKAGE_TEST_IMAGE}.changes")
    }
    prepare_package_image(@interpreter_vm, @os_name, PACKAGE_TEST_IMAGE)
  end

  after :all do
    Dir.chdir(TARGET_DIR) {
      FileUtils.rm("#{PACKAGE_TEST_IMAGE}.image") if File.exists?("#{PACKAGE_TEST_IMAGE}.image")
      FileUtils.rm("#{PACKAGE_TEST_IMAGE}.changes") if File.exists?("#{PACKAGE_TEST_IMAGE}.changes")
    }
  end

  context "by passing all tests" do
    before :all do
      Dir.chdir(TARGET_DIR) {
        FileUtils.cp("#{PACKAGE_TEST_IMAGE}.image", "#{package}.image")
        FileUtils.cp("#{PACKAGE_TEST_IMAGE}.changes", "#{package}.changes")
      }
      run_image_with_cmd(@interpreter_vm, vm_args(@os_name), package, "#{SRC}/package-load-scripts/#{package}.st")
      run_image_with_cmd(@interpreter_vm, vm_args(@os_name), package, "#{SRC}/scripts/show-manifest.st")
    end

    after :all do
      Dir.chdir(TARGET_DIR) {
        FileUtils.rm("#{package}.image") if File.exists?("#{package}.image")
        FileUtils.rm("#{package}.changes") if File.exists?("#{package}.changes")
      }
    end

    it "on Cog" do
      pending "Can't run Cog on this platform (#{identify_os})" if @cog_vm.to_s == ""
      with_copy(package, "cog") { | image_name |
        run_test_with_timeout(@cog_vm, @os_name, image_name, package, TEST_TIMEOUT)
      }
    end

    it "on Cog MT" do
      pending "Can't run Cog MT on this platform (#{identify_os})" if @cog_mt_vm.to_s == ""
      with_copy(package, "cogmt") { | image_name |
        run_test_with_timeout(@cog_mt_vm, @os_name, image_name, package, TEST_TIMEOUT)
      }
    end

    it "on Interpreter" do
      with_copy(package, "interpreter") { | image_name |
        run_test_with_timeout(@interpreter_vm, @os_name, image_name, package, TEST_TIMEOUT)
      }
    end
  end
end

shared_examples "external packages" do
  ["AndreasSystemProfiler",
   "Control",
   "FFI",
   "FileSystem",
   "FileSystem-with-Xtreams",
   "Fuel",
   "Metacello",
   "Nebraska",
   "Nutcracker",
   "OSProcess",
   "Quaternion",
   "ParsingDerivatives",
   "Phexample",
   "RoelTyper",
   "SqueakCheck",
   "ST80",
   "ToolBuilder-MVC",
   "Universes",
   "WebClient",
   "XML-Parser",
   "Xtreams",
   "Zippers"].each { |pkg_name|
    describe pkg_name, pkg_name.to_sym => true do
      let(:package) { pkg_name }
      it_behaves_like "an external package"
    end
  }
end
