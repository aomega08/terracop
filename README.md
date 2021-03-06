# Terracop

Terracop is an opinionated HashiCorp [Terraform](https://www.terraform.io/)
state / plan parser and analyzer. Put it in a CI pipeline to analyze your
Terraform plans or run it on already applied states and see what could be
improved.

The checks run by Terracop go anywhere from resource names guidelines to
identifying security holes in your configuration.

_Terracop is massively inspired by [Rubocop](https://github.com/rubocop-hq/rubocop)._

## Installation

**Terracop** installation is pretty standard:

    $ gem install terracop

If you'd rather install RuboCop using bundler, don't require it in your Gemfile:

    gem 'terracop', require: false

## Compatibility

Terracop can work with state and plan files generated by Terraform 0.12.

## Usage

You can run terracop from the same directory where you would run terraform and
it will automatically pull the state file and analyze it.

If you want to analyze a state file somewhere on your machine you can pass it
like this:

    $ terracop --state path/to/state/file

Terracop can also parse terraform plan files, in order to report potential
issues before you apply the plan and persist the problem. Eg:

    $ terraform plan -out tfplan
    $ terracop --plan tfplan
    $ terraform apply tfplan

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/aomega08/terracop.

## Copyright

Copyright (c) 2019-2020 Francesco Boffa. See [LICENSE.md](LICENSE.md) for further details.
