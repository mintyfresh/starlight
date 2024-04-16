# frozen_string_literal: true

module Discord
  class ModalSubmitData < DiscordObject
    schema schema.strict

    attribute :custom_id, T::Params::String
    attribute :components, T::Params::Array.of(Component)
  end
end
