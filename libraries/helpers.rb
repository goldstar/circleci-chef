unless defined?(CircleciCookbook)
  module CircleciCookbook
    module Helpers
      def get_artifacts(token, project, build_number)
        CircleCi.configure do |config|
          if [chef_proxy.scheme, chef_proxy.host].all?
            config.proxy_host = [chef_proxy.scheme, chef_proxy.host].join('://')
            config.proxy_port = chef_proxy.port if chef_proxy.port
            config.proxy = !config.proxy_host.to_s.empty?
          end
          config.token = token
        end

        username, repo = project.split('/')

        res = CircleCi::Build.artifacts username, repo, build_number
        res.success? ? res.body : []
      end

      def get_artifact_to_download(build_artifacts, source)
        artifact_to_download = nil
        build_artifacts.each do |artifact|
          artifact_to_download = artifact if artifact['pretty_path'].end_with? source
          break unless artifact_to_download.nil?
        end

        artifact_to_download
      end

      def chef_proxy
        URI.parse(Chef::Config['https_proxy'])
      rescue URI::InvalidURIError
        URI::Generic.new(nil, nil, nil, nil, nil, nil, nil, nil, nil)
      end
    end
  end
end

Chef::Resource.send(:include, CircleciCookbook::Helpers)
Chef::Provider.send(:include, CircleciCookbook::Helpers)
