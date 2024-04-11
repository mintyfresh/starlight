# frozen_string_literal: true

module ApplicationHelper
  def form_with(**options, &)
    super(builder: BootstrapFormBuilder, **options, &)
  end
end
