# frozen_string_literal: true

class BootstrapFormBuilder < ActionView::Helpers::FormBuilder
  # @type [Hash {Symbol => Array<String>}]
  FORM_CONTROL_FIELDS = {
    text_field:           %w[form-control],
    text_area:            %w[form-control],
    file_field:           %w[form-control],
    email_field:          %w[form-control],
    telephone_field:      %w[form-control],
    number_field:         %w[form-control],
    password_field:       %w[form-control],
    search_field:         %w[form-control],
    url_field:            %w[form-control],
    datetime_field:       %w[form-control],
    datetime_local_field: %w[form-control],
    date_field:           %w[form-control],
    month_field:          %w[form-control],
    week_field:           %w[form-control],
    time_field:           %w[form-control],
    color_field:          %w[form-control form-control-color]
  }.freeze

  # @param options [Hash]
  # @return [String]
  def group(**options, &)
    @template.content_tag(:div, options, &)
  end

  # @param name [String]
  # @param content_or_options [String, Hash, nil]
  # @param options [Hash]
  # @return [String]
  def label(name, content_or_options = nil, options = {}, &)
    if content_or_options.is_a?(Hash)
      options = content_or_options
      content_or_options = nil
    end

    # skip adding form-label for check-box labels
    include_css_class?(options, 'form-check-label') or
      options = apply_css_class(options, 'form-label')

    super(name, content_or_options, options, &)
  end

  # @param content [String, nil]
  # @param options [Hash]
  # @return [String]
  def help_text(content = nil, **options, &)
    options = apply_css_class(options, 'form-text')

    @template.content_tag(:div, content, options, &)
  end

  FORM_CONTROL_FIELDS.each do |method_name, css_class|
    define_method(method_name) do |name, options = {}, &block|
      options = apply_css_class(options, *css_class)
      options = apply_errors_to_element(options, name)

      super(name, options, &block)
    end
  end

  alias colour_field color_field

  # @param name [String]
  # @param choices [Array<String>, Hash]
  # @param options [Hash]
  # @param html_options [Hash]
  # @return [String]
  def select(name, choices = nil, options = {}, html_options = {}, &)
    html_options = apply_css_class(html_options, 'form-select')
    html_options = apply_errors_to_element(html_options, name)

    super(name, choices, options, html_options, &)
  end

  # @param method [Symbol]
  # @param options [Hash]
  # @param checked_value [String]
  # @param unchecked_value [String]
  # @return [String]
  def check_box(method, options = {}, checked_value = '1', unchecked_value = '0')
    super(method, apply_css_class(options, 'form-check-input'), checked_value, unchecked_value)
  end

  # @param method [Symbol]
  # @param options [Hash]
  # @param label_options [Hash]
  # @param wrapper_options [Hash]
  # @return [String]
  def check(method, options = {}, label_options = {}, wrapper_options = {})
    @template.content_tag(:div, apply_css_class(wrapper_options, 'form-check')) do
      check_box(method, options) + label(method, apply_css_class(label_options, 'form-check-label'))
    end
  end

  # @param method [Symbol]
  # @param options [Hash]
  # @param label_options [Hash]
  # @param wrapper_options [Hash]
  # @return [String]
  def switch(method, options = {}, label_options = {}, wrapper_options = {})
    check(method, options.merge(role: 'switch'), label_options, apply_css_class(wrapper_options, 'form-switch'))
  end

  # @param value [String, Hash, nil]
  # @param options [Hash]
  # @option options [String] :variant
  # @return [String]
  def submit(value = nil, options = {}, &)
    if value.is_a?(Hash) && options.blank?
      options = value
      value   = nil
    end

    variant = options.delete(:variant) || 'primary'
    options = apply_css_class(options, 'btn', "btn-#{variant}")

    super(value, options, &)
  end

  # @param options [Hash]
  # @param css_class [Array<String>]
  # @return [Hash]
  def apply_css_class(options, *css_class)
    options.merge(class: [options[:class], *css_class])
  end

  # @param options [Hash]
  # @param css_class [String]
  # @return [Boolean]
  def include_css_class?(options, css_class)
    options[:class]&.include?(css_class) || false
  end

  # @param options [Hash]
  # @param name [String]
  # @return [Hash]
  def apply_errors_to_element(options, name)
    return options if object.nil? || object.errors.none?

    if errors_for_field(name).present?
      options = apply_css_class(options, 'is-invalid')
      options = options.merge('aria-describedby' => error_field_id(name))
    end

    options
  end

  # @param name [String, Symbol]
  # @return [Array<ActiveModel::Error>]
  def errors_for_field(name)
    name = name.to_s

    errors  = object.errors.where(name)
    errors += object.errors.where(name.chomp('_id')) if name.ends_with?('_id')
    errors += object.errors.where("#{name.chomp('_ids')}s") if name.ends_with?('_ids')

    errors
  end

  # @param name [String, Symbol]
  # @return [String]
  def error_field_id(name)
    field_id(name, :errors)
  end

  # @param name [String, Symbol]
  # @return [String]
  def field_errors(name)
    return if (errors = errors_for_field(name)).blank?

    @template.content_tag(:div, id: error_field_id(name), class: 'invalid-feedback') do
      errors.map { |error| @template.content_tag(:p, error.full_message, class: 'mb-0') }.join.html_safe
    end
  end
end
