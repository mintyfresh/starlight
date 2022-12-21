# frozen_string_literal: true

module SoftDeletable
  extend ActiveSupport::Concern

  class_methods do
    # @return [String] returns a default UUID for the deleted_in column
    def generate_deleted_in
      SecureRandom.uuid
    end

    # @return [Array<ActiveRecord::Reflection>]
    def reflect_on_counter_cache_associations
      reflect_on_all_associations(:belongs_to).select(&:counter_cache_column)
    end

    # @param dependent [Symbol]
    # @return [Array<ActiveRecord::Reflection>]
    def reflect_on_dependent_associations(dependent)
      reflect_on_all_associations
        .select { |reflection| reflection.options[:dependent] == dependent }
        .select { |reflection| reflection.klass.include?(SoftDeletable) }
    end
  end

  included do
    define_model_callbacks :soft_delete, :restore

    belongs_to :deleted_by, class_name: 'User', optional: true

    scope :deleted,         -> { where.not(deleted_at: nil) }
    scope :not_deleted,     -> { where(deleted_at: nil)     }
    scope :unscope_deleted, -> { unscope(where: arel_table[:deleted_at]) }

    around_save :run_soft_delete_callbacks, if: -> { deleted_changed?(to: true) }
    around_save :run_restore_callbacks, if: -> { deleted_changed?(to: false) }

    after_soft_delete :decrement_associated_counters
    after_restore :increment_associated_counters

    after_soft_delete :cascade_soft_delete_to_dependent_associations
    after_restore :cascade_restore_to_dependent_associations
  end

  # @return [void]
  def mark_for_destruction
    self.deleted_at = Time.current
  end

  # @param deleted_in [String, nil]
  # @param deleted_by [User, nil]
  # @return [Boolean]
  def destroy(deleted_in: self.class.generate_deleted_in, deleted_by: nil)
    update(deleted_at: Time.current, deleted_in:, deleted_by:)
  end

  # @return [Boolean]
  def restore
    update(deleted_at: nil, deleted_in: nil, deleted_by: nil)
  end

  # @param deleted_in [String, nil]
  # @param deleted_by [User, nil]
  # @return [Boolean]
  def destroy!(deleted_in: self.class.generate_deleted_in, deleted_by: nil)
    update!(deleted_at: Time.current, deleted_in:, deleted_by:)
  end

  # @return [Boolean]
  def restore!
    update!(deleted_at: nil, deleted_in: nil, deleted_by: nil)
  end

  # @param deleted_in [String, nil]
  # @param deleted_by [User, nil]
  # @return [Boolean]
  def delete(deleted_in: self.class.generate_deleted_in, deleted_by: nil)
    update_columns(deleted_at: Time.current, deleted_in:, deleted_by:) # rubocop:disable Rails/SkipsModelValidations
  end

  # @return [Boolean]
  def undelete
    update_columns(deleted_at: nil, deleted_in: nil, deleted_by_id: nil) # rubocop:disable Rails/SkipsModelValidations
  end

  # @return [Boolean]
  def deleted?
    deleted_at.present?
  end

  alias deleted deleted?

  # @param deleted [Boolean, String, nil]
  # @return [void]
  def deleted=(value)
    if ActiveRecord::Type::Boolean.new.cast(value)
      self.deleted_at = Time.current
      self.deleted_in = self.class.generate_deleted_in
    else
      self.deleted_at = nil
      self.deleted_in = nil
      self.deleted_by = nil
    end
  end

  # @return [Boolean]
  def not_deleted?
    deleted_at.blank?
  end

  # @return [Boolean]
  def deleted_was
    deleted_at_was.present?
  end

  # @param to [Boolean]
  # @param from [Boolean]
  # @return [Boolean]
  def deleted_changed?(from: :__unset__, to: :__unset__)
    return false if deleted == deleted_was
    return false if from != :__unset__ && from != deleted_was
    return false if to != :__unset__ && to != deleted

    true
  end

  # @return [Boolean]
  def deleted_before_last_save
    deleted_at_before_last_save.present?
  end

  # @param from [Boolean]
  # @return [Boolean]
  def saved_change_to_deleted?(from: :__unset__, to: :__unset__)
    return false if deleted == deleted_before_last_save
    return false if from != :__unset__ && from != deleted_before_last_save
    return false if to != :__unset__ && to != deleted

    true
  end

private

  # @return [void]
  def run_soft_delete_callbacks(&)
    run_callbacks(:soft_delete, &)
  end

  # @return [void]
  def run_restore_callbacks(&)
    run_callbacks(:restore, &)
  end

  # @return [void]
  def decrement_associated_counters
    self.class.reflect_on_counter_cache_associations.each do |reflection|
      association(reflection.name).decrement_counters
    end
  end

  # @return [void]
  def increment_associated_counters
    self.class.reflect_on_counter_cache_associations.each do |reflection|
      association(reflection.name).increment_counters
    end
  end

  # @return [void]
  def cascade_soft_delete_to_dependent_associations
    return if deleted_in.blank?

    self.class.reflect_on_dependent_associations(:destroy).each do |reflection|
      association(reflection.name).scope.unscope_deleted.not_deleted.find_each do |record|
        # Propogate the deleted-in transaction identifier to the dependent records
        # This allows all records deleted in the same transaction to be restored together
        # Also propagate the user who deleted the records
        record.destroy!(deleted_in:, deleted_by:)
      end
    end
  end

  # @return [void]
  def cascade_restore_to_dependent_associations
    return if deleted_in.blank?

    self.class.reflect_on_dependent_associations(:destroy).each do |reflection|
      association(reflection.name).scope.unscope_deleted.deleted.where(deleted_in:).find_each(&:restore!)
    end
  end
end
