module ActiveTriples
  module LocalName

    ##
    # Provide a standard interface for minting new IDs and validating
    # the ID is not in use in any known (i.e., registered) repository.
    class Minter

      ##
      # Generate a random ID that does not already exist in the triplestore.
      #
      # @param [Class] the class inheriting from <tt>ActiveTriples::Reource</tt> whose configuration
      #   is used to generate the full URI for testing for uniqueness of the generated local name
      # @param [Integer] the maximum number of attempts to make a unique local name
      # @yieldparam the arguments to pass to the minter block (optional)
      # @yield the function to use to mint the local name.  If not specified, the
      #   +default_minter+ function will be used to generate an UUID.
      # @yieldreturn [String] the generated local name to be tested for uniqueness
      #
      # @return [String] the generated local name
      #
      # @raise [ArgumentError] if maximum allowed tries is less than 0
      # @raise [ArgumentError] if for_class does not inherit from ActiveTriples::Resources
      # @raise [ArgumentError] if minter_block is not a block (does not respond to call)
      # @raise [Exception] if for_class does not have base_uri configured
      # @raise [Exception] if an available local name is not found in the maximum allowed tries.
      #
      # @TODO This is inefficient if max_tries is large. Could try
      #    multi-threading. When using the default_minter included
      #    in this class, it is unlikely to be a problem and should
      #    find an ID within the first few attempts.
      def self.generate_local_name(for_class, max_tries=10, *minter_args, &minter_block)
        raise ArgumentError, 'Argument max_tries must be >= 1 if passed in' if     max_tries    <= 0

        raise ArgumentError, 'Argument for_class must inherit from ActiveTriples::Resource' unless for_class < ActiveTriples::Resource
        raise 'Requires base_uri to be defined in for_class.' unless for_class.base_uri

        raise ArgumentError, 'Invalid minter_block.' if minter_block && !minter_block.respond_to?(:call)
        minter_block = proc { |args| default_minter(args) } unless minter_block

        found   = true
        test_id = nil
        (1).upto(max_tries) do
          test_id = minter_block.call( *minter_args )
          found = for_class.id_persisted?(test_id)
          break unless found
        end
        raise 'Available ID not found.  Exceeded maximum tries.' if found
        test_id
      end

      ##
      # Default minter used by generate_id.
      #
      # @param [Hash] options the options to use while generating the local name
      # @option options [String] :prefix the prefix to put before the generated local name (optional)
      #
      # @note Because <tt>:prefix</tt> is optional, errors in type for <tt>:prefix</tt> are ignored.  Any additional
      #   parameters beyond <tt>:prefix</tt> are also ignored.
      #
      # @note Best practice is to begin localnames with an alpha character.  UUIDs can generate with an alpha or
      #   numeric as the first character.  Pass in an alpha character as <tt>:prefix</tt> to enforce this best
      #   practice.
      #
      # @return [String] a uuid
      def self.default_minter( *options )
        prefix = options[0][:prefix] if ! options.empty? && options[0].is_a?(Hash) && options[0].key?(:prefix)
        local_name = SecureRandom.uuid
        local_name = prefix + local_name if prefix && prefix.is_a?(String)
        local_name
      end
    end
  end
end
