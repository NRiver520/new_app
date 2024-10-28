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

document.addEventListener("DOMContentLoaded", function() {
  const imageInput = document.getElementById("comment_image_input");
  const imagePreview = document.getElementById("image_preview");
  const icon = document.querySelector("label[for='comment_image_input'] i");

  icon.addEventListener("click", function() {
      imageInput.click();
  });

  imageInput.addEventListener("change", function(event) {
      const file = event.target.files[0];
      if (file) {
        const reader = new FileReader();
        reader.onload = function(e) {
          imagePreview.innerHTML = `<img src="${e.target.result}" alt="Image Preview" class="img-fluid" style="max-height: 150px; max-width: 100%;">`;
        };
        reader.readAsDataURL(file);
      } else {
        imagePreview.innerHTML = "";
      }
    });
  });