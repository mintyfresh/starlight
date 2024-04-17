# frozen_string_literal: true

module Bootstrap
  module Helper
    def accordion(**, &)
      Bootstrap::Accordion::Component.new(**).render_in(self, &)
    end

    def alert(text = nil, variant: 'primary', dismissible: false, **, &)
      Bootstrap::Alert::Component.new(text:, variant:, dismissible:, **).render_in(self, &)
    end
  end
end
