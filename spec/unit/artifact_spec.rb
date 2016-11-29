require_relative 'spec_helper'
require_relative '../../libraries/helpers'

describe 'circleci_artifact' do
  let(:chef_run) do
    Chef::Config[:cookbook_path] << './test/cookbooks'
    ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '14.04', step_into: ['circleci_artifact']) do |node|
      node.override['circleci']['artifact_path'] = '/tmp/download.zip'
      node.override['circleci']['project'] = 'goldstar/test'
      node.override['circleci']['build_number'] = 1
      node.override['circleci']['token'] = 'secret'
      node.override['circleci']['source'] = 'build/download.zip'
    end
  end

  it 'does nothing if artifact exists locally' do
    allow_any_instance_of(CircleciCookbook::Helpers).to receive(:get_artifacts).and_return([])
    allow_any_instance_of(CircleciCookbook::Helpers).to receive(:get_artifact_to_download).and_return({'url': 'https://example.com/path/to/artifact'})
    allow(File).to receive(:file?).and_return(true)
    chef_run.converge('circleci_test::default')
    expect(chef_run).to_not create_remote_file('/tmp/download.zip')
  end
end
