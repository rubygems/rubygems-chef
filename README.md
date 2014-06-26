# RubyGems.org infrastructure

This repository contains chef artifacts used to deploy all the different pieces of infrastructure which run RubyGems.org. There are a few patterns which we use and enforce throughout the repo:

1. All cookbooks should live *somewhere* upstream. This could be a developers's GitHub account, or the Chef community site. All the cookbooks in the `cookbooks` directory are wrappers which set attributes, configure necessary LWRP's, and include recipes. The functionality itself comes from the upstream cookbooks.
2. Unless a wrapper cookbooks requires a cookbook for the same software which is different than what's on the Chef community site, all dependencies should be in a wrapper cookbook's `metadata.rb`, rather than in the `Berksfile` located in the root of this repo.
3. No binaries ever go into this repo. They should all live in an apt repository or in S3.

### Chef guidelines

#### General
To run chef on all nodes (staging, common, production) run: `knife ssh "*:*" "sudo chef-client" -x $(whoami)`.

#### Roles
We use roles as minimally as possible. All top-level functionality should be in the appropriate role-specific cookbook (i.e. rubygems-app). We only use roles for easing the use of search.

Run `knife role from file roles/*.rb` after updating any roles to upload them to the Chef server.

#### Environments
Run `knife environment from file environments/*.json` after updating any environments to upload them to the Chef server.

### Bugs and features

GitHub issues are disabled on this repository. Instead, we use [a trello board](https://trello.com/b/cd2HqKnE/infrastructure) to track development work. If you're interested in getting involved with RubyGems.org's infrastructure team, that trello board is a great place to look for things to work on.

### Wiki
This readme has some high-level information in it, but our [wiki](https://github.com/rubygems/rubygems-infrastructure/wiki) is where you can find more advanced and complete information about the RubyGems.org infrastructure.

### Development Setup

[ChefDK](http://www.getchef.com/downloads/chef-dk) is the recommended way to get the different tools necessary to manage, install, and test our chef deployment. It includes things like an embedded Ruby, [Berkshelf](http://berkshelf.com/), and [Test Kitchen](http://kitchen.ci/). After you've download and installed the necessary ChefDK package for your platform, run `/opt/chefdk/embedded/bin/bundle install --local` to add a few tools we use which are not included in the ChefDK packages.

If you'd prefer to avoid ChefDK, then you will need to have Ruby 2.0 and Bundler installed. Then run `bundle install --local` to install all the gems required for development.

### License

This repository is free software made available under the MIT license. You can view the full text of the license in the `LICENSE` file included as part of this repository. That file must be redistributed.

It should be noted that some files in this repository are included with licensed other than MIT. These files have a header with their license information and those licenses are compatible with the MIT license.
