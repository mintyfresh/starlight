# frozen_string_literal: true

class BootstrapFormBuilder < ActionView::Helpers::FormBuilder
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

  # @param name [String]
  # @param options [Hash]
  # @return [String]
  def text_area(name, options = {}, &)
    options = apply_css_class(options, 'form-control')
    options = apply_errors_to_element(options, name)

    super(name, options, &)
  end

  # @param name [String]
  # @param options [Hash]
  # @return [String]
  def text_field(name, options = {}, &)
    options = apply_css_class(options, 'form-control')
    options = apply_errors_to_element(options, name)

    super(name, options, &)
  end

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

  def field_errors(name)
    return if (errors = errors_for_field(name)).blank?

    @template.content_tag(:div, id: error_field_id(name), class: 'invalid-feedback') do
      errors.map { |error| @template.content_tag(:p, error.full_message, class: 'mb-0') }.join.html_safe
    end
  end
end
