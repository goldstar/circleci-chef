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

  let(:helpers) { Class.new { extend CircleciCookbook::Helpers } }

  it 'does nothing if artifact exists locally' do
    allow(File).to receive(:file?).and_return(true)
    chef_run.converge('circleci_test::default')

    expect(chef_run).to_not create_remote_file('/tmp/download.zip')
  end

  it 'does nothing if no artficat matching source is found in CircleCI' do
    allow_any_instance_of(CircleciCookbook::Helpers).to receive(:get_artifacts).and_return([])
    chef_run.converge('circleci_test::default')

    expect(chef_run).to_not create_remote_file('/tmp/download.zip')
  end

  it 'will download artifact when found' do
    artifact = {
      'pretty_path' => '/path/to/build/download.zip',
      'url' => 'https://example.com/path/to/artifact'
    }

    allow_any_instance_of(CircleciCookbook::Helpers).to receive(:get_artifacts).and_return([artifact])
    chef_run.converge('circleci_test::default')

    expect(chef_run).to create_remote_file('/tmp/download.zip')
  end

  it "doesn't use the proxy when chef isn't proxied" do
    allow(CircleCi::Build).to receive(:artifacts).and_return( double(success?: false) )
    helpers.get_artifacts('fake_token', 'company/project', 123)

    expect(CircleCi.config.proxy_host).to eq(nil)
    expect(CircleCi.config.proxy_port).to eq(80)
    expect(CircleCi.config.proxy).to eq(false)
  end

  it 'uses the proxy when chef is proxied' do
    stub_const('Chef::Config', 'https_proxy' => 'http://example.com:1234' )
    allow(CircleCi::Build).to receive(:artifacts).and_return( double(success?: false) )
    helpers.get_artifacts('fake_token', 'company/project', 8)

    expect(CircleCi.config.proxy_host).to eq('http://example.com')
    expect(CircleCi.config.proxy_port).to eq(1234)
    expect(CircleCi.config.proxy).to eq(true)
  end

end
