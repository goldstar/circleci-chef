require 'circleci'

use_inline_resources

actions :download, :delete

default_action :download if defined?(default_action)

attribute :project, :kind_of => String, :required => true
attribute :build_number, :kind_of => Integer, :required => true
attribute :token, :kind_of => String, :required => true
attribute :source, :kind_of => String, :required => true
attribute :path, :kind_of => String, :required => true, :name_attribute => true
attribute :owner, :kind_of => [String, Integer], :required => false, :default => 'root'
attribute :group, :kind_of => [String, Integer], :required => false, :default =>
attribute :mode, :kind_of => [String, Integer], :required => false, :default => '0644'

def get_artifacts(token, project, build_number)
  CircleCi.configure do |config|
    config.token = token
  end

  username, repo = project.split('/')
  
  res = CircleCi::Build.artifacts username, repo, build_number 
  if res.success?
    return []
  else
    return res.body
  end
end

def load_current_resource

  resource_name = "#{@new_resource.name}-#{@new_resource.build_number}"
  @current_resource = Chef::Resource::CircleciArtifact.new(resource_name)

  @current_resource.project(@new_resource.project)
  @current_resource.build_number(@new_resource.build_number)
  @current_resource.token(@new_resource.token)
  @current_resource.owner(@new_resource.owner)
  @current_resource.group(@new_resource.group)
  @current_resource.mode(@new_resource.mode)

  @current_resource.exists = ::File.file?(@new_resource.path)
end

action :download do
  if @current_resource.exists
    Chef::Log.info "#{@current_resource.path} already downloaded."
  else
    build_artifacts = get_artifacts(@current_resource.token,
      @current_resource.project, @current_resource.build_number)

    artifact_to_download = nil
    build_artifacts.each do |artifact|
      if artifact['pretty_path'].ends_with? @current_resource.source 
        artifact_to_download = artifact
      end
  
      break if !artifact_to_download.nil?
    end

    if artifact_to_download.nil?
      Chef::Log.error "No artifact found for #{@current_resource.source}!"
      return  # Nothing left to do here.
    end

    # Add our CircleCI token to the artifact URL.
    url_of_artifact = "#{artifact_to_download['url']}?token=#{@current_resource.token}"
    Chef::Log.info "Downloading artifact #{artifact_to_download['url']} ..."

    f = remote_file @current_resource.path do
      source url_of_artifact
      owner @current_resource.owner
      group @current_resource.group
      mode @current_resource.owner
    end

    Chef::Log.info "#{@current_resource.path} has been downloaded."
    @new_resource.updated_by_last_action(f.updated_by_last_action?)
  end
end
