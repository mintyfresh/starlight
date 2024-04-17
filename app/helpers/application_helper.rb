# frozen_string_literal: true

module ApplicationHelper
  include Bootstrap::Helper

  def form_with(**options, &)
    super(builder: Bootstrap::FormBuilder, **options, &)
  end
end
