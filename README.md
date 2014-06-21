# RubyGems.org infrastructure

This repository contains chef artifacts used to deploy all the different pieces of infrastructure which run RubyGems.org. There are a few patterns which we use and enforce throughout the repo:

1. All cookbooks should live *somewhere* upstream. This could be a developers's GitHub account, or the Chef community site. All the cookbooks in the `cookbooks` directory are wrappers which set attributes, configure necessary LWRP's, and include recipes. The functionality itself comes from the upstream cookbooks.
2. Unless a wrapper cookbooks requires a cookbook for the same software which is different than what's on the Chef community site, all dependencies should be in a wrapper cookbook's `metadata.rb`, rather than in the `Berksfile` located in the root of this repo.
3. No binaries ever go into this repo. They should all live in an apt repository or in S3.

## Development Setup

You will need **ruby 2.0** and **bundler** installed. Run `bundle install --local`.
