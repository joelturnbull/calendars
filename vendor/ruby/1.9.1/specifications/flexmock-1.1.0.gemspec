# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "flexmock"
  s.version = "1.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jim Weirich"]
  s.date = "2012-10-30"
  s.description = "\n      FlexMock is a extremely simple mock object class compatible\n      with the Test::Unit framework.  Although the FlexMock's\n      interface is simple, it is very flexible.\n    "
  s.email = "jim.weirich@gmail.com"
  s.extra_rdoc_files = ["README.rdoc", "CHANGES", "doc/examples/rspec_examples_spec.rdoc", "doc/examples/test_unit_examples_test.rdoc", "doc/GoogleExample.rdoc", "doc/releases/flexmock-0.4.0.rdoc", "doc/releases/flexmock-0.4.1.rdoc", "doc/releases/flexmock-0.4.2.rdoc", "doc/releases/flexmock-0.4.3.rdoc", "doc/releases/flexmock-0.5.0.rdoc", "doc/releases/flexmock-0.5.1.rdoc", "doc/releases/flexmock-0.6.0.rdoc", "doc/releases/flexmock-0.6.1.rdoc", "doc/releases/flexmock-0.6.2.rdoc", "doc/releases/flexmock-0.6.3.rdoc", "doc/releases/flexmock-0.6.4.rdoc", "doc/releases/flexmock-0.7.0.rdoc", "doc/releases/flexmock-0.7.1.rdoc", "doc/releases/flexmock-0.8.0.rdoc", "doc/releases/flexmock-0.8.2.rdoc", "doc/releases/flexmock-0.8.3.rdoc", "doc/releases/flexmock-0.8.4.rdoc", "doc/releases/flexmock-0.8.5.rdoc", "doc/releases/flexmock-0.9.0.rdoc", "doc/releases/flexmock-1.0.0.rdoc", "doc/releases/flexmock-1.0.3.rdoc"]
  s.files = ["README.rdoc", "CHANGES", "doc/examples/rspec_examples_spec.rdoc", "doc/examples/test_unit_examples_test.rdoc", "doc/GoogleExample.rdoc", "doc/releases/flexmock-0.4.0.rdoc", "doc/releases/flexmock-0.4.1.rdoc", "doc/releases/flexmock-0.4.2.rdoc", "doc/releases/flexmock-0.4.3.rdoc", "doc/releases/flexmock-0.5.0.rdoc", "doc/releases/flexmock-0.5.1.rdoc", "doc/releases/flexmock-0.6.0.rdoc", "doc/releases/flexmock-0.6.1.rdoc", "doc/releases/flexmock-0.6.2.rdoc", "doc/releases/flexmock-0.6.3.rdoc", "doc/releases/flexmock-0.6.4.rdoc", "doc/releases/flexmock-0.7.0.rdoc", "doc/releases/flexmock-0.7.1.rdoc", "doc/releases/flexmock-0.8.0.rdoc", "doc/releases/flexmock-0.8.2.rdoc", "doc/releases/flexmock-0.8.3.rdoc", "doc/releases/flexmock-0.8.4.rdoc", "doc/releases/flexmock-0.8.5.rdoc", "doc/releases/flexmock-0.9.0.rdoc", "doc/releases/flexmock-1.0.0.rdoc", "doc/releases/flexmock-1.0.3.rdoc"]
  s.homepage = "https://github.com/jimweirich/flexmock"
  s.rdoc_options = ["--title", "FlexMock", "--main", "README.rdoc", "--line-numbers"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.10"
  s.summary = "Simple and Flexible Mock Objects for Testing"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
