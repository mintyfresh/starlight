# frozen_string_literal: true

module Discord
  class DiscordObject < Dry::Struct
    module T
      include Dry.Types

      LocalizationsMap = Hash.map(String, String)
    end

    transform_keys(&:to_sym)
  end
end
