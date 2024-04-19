// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import 'popper'
import 'bootstrap'

document.addEventListener('DOMContentLoaded', function() {
  // find all elements with the data-default-value="current-time-zone" attribute
  document.querySelectorAll('[data-default-value="current-time-zone"]').forEach((element) => {
    if (!element.value) {
      element.value = Intl.DateTimeFormat().resolvedOptions().timeZone
    }
  })
})
