# ActiveTriples::LocalName

[![Build Status](https://travis-ci.org/ActiveTriples/active_triples-local_name.png?branch=master)](https://travis-ci.org/ActiveTriples/active_triples-local_name)
[![Coverage Status](https://coveralls.io/repos/ActiveTriples/active_triples-local_name/badge.png?branch=setup_coveralls)](https://coveralls.io/r/ActiveTriples/active_triples-local_name?branch=setup_coveralls)
[![Dependency Status](https://www.versioneye.com/ruby/ActiveTriples-active_triples-local_name/0.0.4/badge.svg)](https://www.versioneye.com/ruby/ActiveTriples-active_triples-local_name/0.0.4)

Provides utilities for working with local names under the [ActiveTriples](https://github.com/ActiveTriples/ActiveTriples) 
framework.  Includes a default implementation of a local name minter.


## Installation

Add this line to your application's Gemfile:

    gem 'active_triples-local_name'

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install active_triples-local_name


## Usage

**Utilities**

* Local Name Minter
* Others may be added in the future.


### Local Name Minter

Common prep code for all examples:
```ruby
require 'active_triples'
require 'active_triples/local_name'

# create an in-memory repository for ad-hoc testing
ActiveTriples::Repositories.add_repository :default, RDF::Repository.new

# create a DummyResource for ad-hoc testing
# NOTE: local name minter requires resource class to have base_uri configured
class DummyResourceWithBaseURI < ActiveTriples::Resource
  configure :base_uri => "http://example.org",
            :type => RDF::URI("http://example.org/SomeClass"),
            :repository => :default
end
```

#### Example: Using default minter
```ruby
# create a new resource with a minted local name using default minter
localname = ActiveTriples::LocalName::Minter.generate_local_name(
              DummyResourceWithBaseURI, 10, {:prefix=>'d'})
# => something like -- "http://example.org/d59beebc5-5238-4aad-bf92-f63fbbd8faaa"
```

Parameter NOTES:
* for_class = DummyResourceWithBaseURI - resource class must have base_uri configured
* max_tries = 10 - If using default minter, it should easily find an available local name in 10 tries.  
  If your minter algorithm gets lots of clashes with existing URIs and max_tries is set high, you may 
  run into performance issues.
* minter_args (optional) = {:prefix=>'d'} - The default minter takes a single hash argument.  You can
  define minters that take no arguments, multiple arguments, or a multiple item hash argument.
* minter_block = nil - When minter_block is not passed in, the default minter algorithm, which produces
  a UUID, will be used.  Best practice is to start local names with an alpha character.  UUIDs generate 
  with either an alpha or numeric as the first character. Passing in a prefix of 'd' forces the local 
  name to start with the character 'd'.


#### Example: Passing in a block as minter

```ruby
# create a new resource with a minted local name using passed in block
localname = ActiveTriples::LocalName::Minter.generate_local_name(
              DummyResourceWithBaseURI,10,'d') do |prefix|
                prefix ||= ""
                local_name = SecureRandom.uuid
                local_name = prefix + "_blockproc_" + local_name if prefix && prefix.is_a?(String)
                local_name
              end
# => something like -- "http://example.org/d_blockproc_59beebc5-5238-4aad-bf92-f63fbbd8faaa"
```


#### Example: Passing in a method as minter
```ruby
# minter method
def uuid_minter( *options )
  prefix = options[0][:prefix] if ! options.empty? && options[0].is_a?(Hash) && options[0].key?(:prefix)
  local_name = SecureRandom.uuid
  local_name = prefix + "_method_" + local_name if prefix && prefix.is_a?(String)
  local_name
end

# create a new resource with a minted local name using a minter method
localname = ActiveTriples::LocalName::Minter.generate_local_name(
              DummyResourceWithBaseURI,10,{:prefix=>"d"}) {|args| uuid_minter(args)}
# => something like -- "http://example.org/d_method_59beebc5-5238-4aad-bf92-f63fbbd8faaa"
```

#### Example: Override default minter.
```ruby
# minter method
module ActiveTriples
  module LocalName
    class Minter
      def self.default_minter( *options )
        prefix = options[0][:prefix] if ! options.empty? && options[0].is_a?(Hash) && options[0].key?(:prefix)
        local_name = SecureRandom.uuid
        local_name = prefix + "_default_" + local_name if prefix && prefix.is_a?(String)
        local_name
      end
    end
  end
end

# create a new resource with a minted local name using override of default minter
localname = ActiveTriples::LocalName::Minter.generate_local_name(
              DummyResourceWithBaseURI,10,{:prefix=>"d"})
# => something like -- "http://example.org/d_default_59beebc5-5238-4aad-bf92-f63fbbd8faaa"
```

See more examples in spec/active_triples/local_name/minter_spec.rb.


## Contributing

Please observe the following guidelines:

 - Do your work in a feature branch based on ```master``` and rebase before submitting a pull request.
 - Write tests for your contributions.
 - Document every method you add using YARD annotations. (_Note: Annotations are sparse in the existing codebase, help us fix that!_)
 - Organize your commits into logical units.
 - Don't leave trailing whitespace (i.e. run ```git diff --check``` before committing).
 - Use [well formed](http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html) commit messages.

