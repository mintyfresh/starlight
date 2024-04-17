# frozen_string_literal: true

module Bootstrap
  module Helper
    def accordion(**, &)
      Bootstrap::Accordion::Component.new(**).render_in(self, &)
    end

    def alert(text = nil, variant: 'primary', dismissible: false, **, &)
      Bootstrap::Alert::Component.new(text:, variant:, dismissible:, **).render_in(self, &)
    end

    # Constructs a bootstrap nav-link elements with the given label and path.
    # Automatically applies the 'active' CSS class if the current page matches the given path.
    #
    # @param label [String]
    # @param path [String]
    # @param options [Hash]
    # @return [String]
    def nav_link_to(label, path, check_parameters: false, **options, &)
      options = apply_css_class(options, 'nav-link')

      if current_page?(path, check_parameters:)
        options = apply_css_class(options, 'active')
        options = options.deep_merge(aria: { current: 'page' })
      end

      tag.li(class: 'nav-item') do
        link_to(label, path, options, &)
      end
    end

    # Given an options Hash for a Rails view helper, apply the given CSS classes.
    #
    # @param options [Hash]
    # @param classes [Array<String>]
    # @return [Hash]
    def apply_css_class(options, *classes)
      options.merge(class: [*options[:class], *classes])
    end
  end
end
