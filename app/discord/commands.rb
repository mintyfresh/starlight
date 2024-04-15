# frozen_string_literal: true

module Commands
  # @return [Array<Commands::Base>]
  def self.all
    @all ||= constants(false).map { |name| const_get(name) }.select { |klass| klass < Base }.freeze
  end

  # @param name [String]
  # @return [Commands::Base, nil]
  def self.find(name)
    all.find { |klass| klass.command_name == name }
  end

  # @param request [Discord::Interaction::Request]
  # @return [Discord::Interaction::Response]
  def self.call(request)
    if (command = find(request.data.name))
      command.new(request).call
    else
      Discord::Interaction::Response.channel_message(
        content: "Unknown command: #{request.data.name}",
        flags:   Discord::MessageFlags::EPHEMERAL
      )
    end
  end
end
