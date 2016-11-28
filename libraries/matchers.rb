if defined?(ChefSpec)
  def download_circleci_artifact(artifact)
    ChefSpec::Matchers::ResourceMatcher.new(:circleci_artifact,
                                            :download, artifact)
  end

  def delete_circleci_artifact(artifact)
    ChefSpec::Matchers::ResourceMatcher.new(:circleci_artifact,
                                            :delete, artifact)
  end
end
