# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  extend HasUniqueAttribute
  extend WhereAny

  primary_abstract_class

  # Encrypts a database column using Lockbox and the application encryption key by default.
  # See: https://github.com/ankane/lockbox#active-record
  #
  # Extended to also allow for blind-indices to be defined via the `blind_index` argument.
  # Options are forwarded to the `blind_index` method: https://github.com/ankane/blind_index#getting-started
  #
  # @param names [Array<Symbol>] The names of the attributes to be encrypted
  # @param blind_index [Boolean, Hash] Whether to use a blind index, or a hash of options to pass to the blind index
  # @return [void]
  def self.has_encrypted(*names, blind_index: false, **options) # rubocop:disable Naming/PredicateName
    super(*names, **options)
    blind_index(*names, **(blind_index.is_a?(Hash) ? blind_index : {})) if blind_index
  end

  # Defines a list of attributes that will automatically be stripped of extraneous whitespace.
  #
  # @param names [Array<Symbol>] The names of the attributes to be stripped of whitespace
  # @param squish [Boolean] Whether to also squish consecutive whitespace into a single space
  # @return [void]
  def self.strips_whitespace_from(*names, squish: false)
    method = squish ? :squish : :strip

    names.each do |name|
      before_validation if: -> { send("#{name}_changed?") } do
        send("#{name}=", send(name).try(method))
      end
    end
  end
end
