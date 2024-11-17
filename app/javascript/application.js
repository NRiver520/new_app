// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
import * as bootstrap from "bootstrap/dist/js/bootstrap"

document.addEventListener('turbo:load', function() {
  $('#board-title-search').autocomplete({
    source: function(request, response) {
      $.ajax({
        url: '/boards/autocomplete',
        dataType: 'json',
        data: {
          term: request.term
        },
        success: function(data) {
          response(data);
        },
        error: function(xhr, status, error) {
          console.error('Autocomplete request failed:', status, error);
        }
      });
    },
    minLength: 2
  });
});
