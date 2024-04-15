# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  extend HasUniqueAttribute

  primary_abstract_class

  # @param attributes [Array<Symbol>] the names of the attributes to normalize
  # @param with [Symbol] the name of the method to call to strip the value
  # @param prune_null_bytes [Boolean] whether to remove null bytes from the value
  # @return [void]
  def self.strips_whitespace_from(*attributes, with: :strip, prune_null_bytes: true)
    normalizes(*attributes, with: lambda { |value|
      value = value.send(with)
      value = value.delete("\u0000") if prune_null_bytes

      value
    })
  end

  # @param attributes [Array<Symbol>]
  # @param time_zone [Symbol]
  # @return [void]
  def self.timestamps_from_parts(*attributes, time_zone:)
    attributes.each do |attribute|
      timestamp_from_parts(attribute, date: :"#{attribute}_date", time: :"#{attribute}_time", time_zone:)
    end
  end

  # @param attribute [Symbol]
  # @param date [Symbol]
  # @param time [Symbol]
  # @param time_zone [Symbol, nil]
  # @return [void]
  def self.timestamp_from_parts(attribute, time_zone:, date: :"#{attribute}_date", time: :"#{attribute}_time")
    class_eval(<<-RUBY, __FILE__, __LINE__ + 1)
      # def starts_at
      #   build_timestamp_from_parts(starts_at_date, starts_at_time, time_zone)
      # end
      def #{attribute}
        build_timestamp_from_parts(#{date}, #{time}, #{time_zone})
      end

      # def starts_at=(timestamp)
      #   self.starts_at_date, self.starts_at_time = extract_parts_from_timestamp(timestamp)
      # end
      def #{attribute}=(timestamp)
        self.#{date}, self.#{time} = extract_parts_from_timestamp(timestamp)
      end
    RUBY
  end

  # @!method human_attribute_name(attribute, options = {})
  #   @param attribute [Symbol]
  #   @param options [Hash]
  #   @return [String]
  delegate :human_attribute_name, to: :class

protected

  # @param date [Date, nil]
  # @param time [String, nil]
  # @param time_zone [String, nil]
  # @return [ActiveSupport::TimeWithZone, nil]
  def build_timestamp_from_parts(date, time, time_zone)
    date && time && time_zone && ActiveSupport::TimeZone[time_zone]&.parse("#{date} #{time}")
  end

  # @param timestamp [ActiveSupport::TimeWithZone, String, nil]
  # @return [Array<Date, String>, Array<nil, nil>]
  def extract_parts_from_timestamp(timestamp)
    case timestamp
    when ActiveSupport::TimeWithZone, Time
      [timestamp.to_date, timestamp.strftime('%H:%M:%S')]
    when String
      timestamp.split(/ |T/, 2)
    when nil
      [nil, nil]
    else
      raise ArgumentError, "Invalid timestamp: #{timestamp.inspect} (expected Time, String, or nil)"
    end
  end
end
