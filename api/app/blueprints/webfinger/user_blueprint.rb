# frozen_string_literal: true

module Webfinger
  class UserBlueprint < ApplicationBlueprint
    DOMAIN      = 'starlight.social'
    NAME_URI    = URI::HTTPS.build(host: DOMAIN, path: '/ns/name').freeze
    POSTS_COUNT = URI::HTTPS.build(host: DOMAIN, path: '/ns/posts_count').freeze

    field :subject do |user, _|
      "#{ERB::Util.url_encode(user.display_name)}@#{DOMAIN}"
    end
    field :properties do |user, _|
      {
        NAME_URI    => user.display_name,
        POSTS_COUNT => user.posts_count
      }
    end
  end
end
