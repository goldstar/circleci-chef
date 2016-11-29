require 'chefspec'
require 'chefspec/berkshelf'

RSpec.configure do |config|
  config.cookbook_path = './test/cookbooks'
  config.platform = 'ubuntu'
  config.version = '14.04'
end
