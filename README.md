# Doggo

[![License](https://img.shields.io/badge/license-mit-blue.svg)](https://opensource.org/licenses/MIT)

An  [RSpec](https://github.com/rspec) formatter that looks like `--format documentation`, but adds an indication of test number and overall test count at the start of each line.

## Example output

Regenerate this with `FOR_EXAMPLE=yes bundle exec rspec --order defined`:

```
[   10] Doggo examples
[01/10]   outer passes
[02/10]   FAILED (1) - outer fails
[03/10]   PENDING - outer is pending with xit
[04/10]   FAILED (2) - outer is pending with a custom message
[   10]   in a context
[   10]     with a nested context
[05/10]       passes
[06/10]       FAILED (3) - fails
[07/10]       PENDING - is pending with xit
[08/10]       FAILED (4) - is pending with a custom message
[   10]   test count
[09/10]     is taken to 9
[10/10]     is taken to 10, showing leading zero pad formatting
```

Notable things are:

* Group title entries omit the example number
* Left zero padding to keep column alignment, working for any number of total tests
* `FAILED` and `PENDING` states are shown on the left side of the message, not the right as with RSpec's `--format documentation`, to make them a little easier to see in CI output
* A `PENDING` default message of `Temporarily skipped with xit` is suppressed for brevity, but any other message would be shown inline.

## Installation

Either:

```shell
gem install doggo
```

...or in a Gemfile:

```ruby
gem 'doggo', '~> 1.0'
```

## Usage

Drive RSpec with:

```
rspec --format Doggo
```

Alternatively, edit your `.rspec` file:

```
# .rspec

--format Doggo
```

...or alter your `spec_helper.rb` file or equivalent:

```ruby
RSpec.configure do | config |
  config.add_formatter 'Doggo'
end
```

## Development

Doggo works with Ruby 1.9.3-p551 from November 13th 2011, but needs a far newer RubyGems version in order for its `.gemspec` file to be processed. You will therefore probably need to update RubyGems if you are doing development work on the source code and want to, for example, run `bundle update`. _Assuming you are using [rbenv](https://github.com/rbenv/rbenv)_ and have automatically (via Doggo's `.ruby-version` file) or manually (via e.g. running command `rbenv local 1.9.3-p551`) switched to Ruby 1.9.3-p551, you can safely ensure that the most recent compatible RubyGems version is installed by issuing this command:

```
gem update --system 2.7.10
```

According to the [release history](https://rubygems.org/gems/rubygems-update/versions), 2.7.10 is the last of the v2.x RubyGems releases which still supported Ruby v1.x. Version 2.7.10 was released on June 14th 2019.
