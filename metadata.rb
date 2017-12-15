name             'circleci'
maintainer       'Joe Stump'
maintainer_email 'jstump@goldstar.com'
license          'Apache-2.0'
description      'Installs/Configures circleci'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.2'
issues_url       'https://github.com/goldstar/circleci-chef/issues'
source_url       'https://github.com/goldstar/circleci-chef'

chef_version '>= 12.5' if respond_to?(:chef_version)
supports %w[ubuntu debian]
