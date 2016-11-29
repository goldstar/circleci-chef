resource_name :circleci_artifact

property :project, String
property :build_number, Integer
property :token, String
property :source, String
property :path, String, name_attribute: true
property :owner, [String, Integer], default: 'root'
property :group, [String, Integer], default: 'root'
property :mode, [String, Integer], default: '0644'

default_action :download if defined?(default_action)

action :download do
  unless ::File.file?(path)
    build_artifacts = get_artifacts(token, project, build_number)
    artifact_to_download = get_artifact_to_download(build_artifacts,
                                                    source)

    if artifact_to_download.nil?
      Chef::Log.error "No artifact found for #{source}!"
      return # Nothing left to do here.
    end

    url_of_artifact = "#{artifact_to_download['url']}?circle-token=#{token}"
    Chef::Log.info "Found artifact at #{artifact_to_download['url']} ..."

    remote_file path do
      source url_of_artifact
      owner owner
      group group
      mode owner
    end
  end
end
