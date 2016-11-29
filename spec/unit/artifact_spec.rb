require_relative 'spec_helper'
require_relative '../../libraries/helpers'

describe 'circleci_artifact' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(step_into: ['circleci_artifact']) do |node|
      node.override['circleci']['artifact_path'] = '/tmp/download.zip'
      node.override['circleci']['project'] = 'goldstar/test'
      node.override['circleci']['build_number'] = 1
      node.override['circleci']['token'] = 'secret'
      node.override['circleci']['source'] = 'build/download.zip'
    end
  end

  it 'does nothing if artifact exists locally' do
    allow(File).to receive(:file?).and_return(true)
    chef_run.converge('circleci_test::default')

    expect(chef_run).to_not create_remote_file('/tmp/download.zip')
  end

  it 'will download artifact when found' do
    artifact = {
        'pretty_path' => '/path/to/build/download.zip',
        'url' => 'https://example.com/path/to/artifact'
    }.stringify_keys

    allow_any_instance_of(CircleciCookbook::Helpers).to receive(:get_artifacts).and_return([artifact])
    chef_run.converge('circleci_test::default')

    expect(chef_run).to create_remote_file('/tmp/download.zip')    
  end
end
