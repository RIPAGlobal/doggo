# Papercut

[![License](https://img.shields.io/badge/license-mit-blue.svg)](https://opensource.org/licenses/MIT)

A  [RSpec][https://github.com/rspec] formatter that looks like `--format documentation`, but adds an indication of test number and overall test count at the start of each line.

## Example output


## Installation

Either:

```shell
gem install doggo
```

...or in a Gemfile:

```ruby
gem 'doggo'
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
