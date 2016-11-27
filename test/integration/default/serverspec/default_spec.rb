require 'spec_helper'

describe 'circleci_test::default' do
  it 'should download the artifact' do
    expect(file('/tmp/download.zip')).to be_file
  end
end
