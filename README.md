[![CircleCI](https://circleci.com/gh/goldstar/circleci-chef/tree/master.svg?style=svg)](https://circleci.com/gh/goldstar/circleci-chef/tree/master)
[![Dependency Status](https://gemnasium.com/badges/github.com/goldstar/circleci-chef.svg)](https://gemnasium.com/github.com/goldstar/circleci-chef)

# `circleci`

A set of Chef LWRPs for interfacing with CircleCI.

## Requirements

### Platforms

- Ubuntu 14.04 

### Chef

- Chef 12.0 or later


## Usage

### `circleci::default`

Add `circleci` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[circleci]"
  ]
}
```

This recipe installs Gems required by the CircleCI LWRP.

## Resources

### `circleci_artifact`

Downloads the specified CircleCI build artifact.

### Actions

- `download` - Download a CircleCI build artifact (default)

### Properties:

- `project` - The CircleCI project path. (e.g. `goldstar/circleci-chef`)
- `build_number` - The build number to download the artifact from.
- `token` - A valid CircleCI API token.
- `source` - The artifact name. Can be any part of the suffic of the artifact path. (e.g. `build/out.tar.gz`)
- `path` - The local path to save the artifact to. Defaults to the resource name.
- `owner` - Who will own the downloaded artifact. Defaults to `root`.
- `group` - Which group will own the downloaded artifact. Defaults to `root`.
- `mode` - The mode of the downloaded artifact. Defaults to `0644`.

### Example:

```ruby
build_number = node['myapp']['build_number']
circleci_artifact "/usr/local/builds/#{build_number}.zip" do
  token node['myapp]['circlci_api_token'] 
  source "build/output.zip"
  action :download
end
```
