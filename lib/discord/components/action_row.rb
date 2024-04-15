# frozen_string_literal: true

module Discord
  module Components
    class ActionRow < DiscordObject
      NestableComponent =
        Button |
        SelectMenu |
        TextInput

      attribute :type, T::Params::Integer.constrained(eql: ComponentType::ACTION_ROW).default(ComponentType::ACTION_ROW)
      attribute :components, T::Params::Array.of(NestableComponent)
    end
  end
end
