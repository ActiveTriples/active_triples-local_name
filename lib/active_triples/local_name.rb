# require 'rdf'
require 'active_triples/local_name/version'
require 'active_support'

module ActiveTriples
  module LocalName
    extend ActiveSupport::Autoload
    eager_autoload do
      autoload :Minter
    end

    def self.post_ActiveTriples_0_7?
      ActiveTriples.constants.include?(:RDFSource)
    end
  end
end

