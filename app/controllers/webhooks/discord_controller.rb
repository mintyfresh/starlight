# frozen_string_literal: true

module Webhooks
  class DiscordController < BaseController
    DISCORD_PUBLIC_KEY       = ENV.fetch('DISCORD_PUBLIC_KEY')
    DISCORD_PUBLIC_KEY_BYTES = [DISCORD_PUBLIC_KEY].pack('H*').freeze
    DISCORD_VERIFY_KEY       = Ed25519::VerifyKey.new(DISCORD_PUBLIC_KEY_BYTES)
    DISCORD_REQUEST_MAX_AGE  = 45.seconds
    DISCORD_REQUEST_MIN_AGE  = -10.seconds

    before_action :validate_request_signature!

    def callback
      request = Discord::Interaction::Request.new(params.to_unsafe_hash)

      case request.type
      when Discord::Interaction::RequestType::PING
        render json: Discord::Interaction::Response.pong
      else
        # TODO: Implement me.
        head :ok
      end
    end

  private

    # @return [void]
    def validate_request_signature!
      signature = request.headers['X-Signature-Ed25519']
      timestamp = request.headers['X-Signature-Timestamp']
      return if timestamp_valid?(timestamp) && signature_valid?(signature, timestamp)

      head :unauthorized
    end

    # Checks that the request timestamp is within the allowed time range.
    #
    # @param timestamp [String]
    # @return [Boolean]
    def timestamp_valid?(timestamp)
      return false if timestamp.blank?

      delta_time = Time.current - Time.zone.at(timestamp.to_i)
      logger.warn  { "Request delta is negative: #{delta_time}" } if delta_time.negative?
      logger.debug { "Request delta time: #{delta_time}" }

      delta_time.between?(DISCORD_REQUEST_MIN_AGE, DISCORD_REQUEST_MAX_AGE)
    end

    # Checks that the request was signed by Discord matching our public key.
    #
    # @param signature [String]
    # @param timestamp [String]
    # @return [Boolean]
    def signature_valid?(signature, timestamp)
      return false if signature.blank? || timestamp.blank?

      DISCORD_VERIFY_KEY.verify(
        [signature].pack('H*'),
        "#{timestamp}#{request.raw_post}"
      )
    rescue Ed25519::VerifyError => error
      logger.error { "Invalid signature: #{error}" }
      logger.debug { "Signature: #{signature.inspect}" }
      logger.debug { "Timestamp: #{timestamp.inspect}" }

      false
    end
  end
end
