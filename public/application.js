// Header with discount type name
function active_title() { return document.querySelector('.active-title'); }
function first_title() { return document.querySelector('.discount-type .discount-type-title'); }
function discount_types() { return document.querySelectorAll('.discount-type'); }

function replace_active_title() {
  discount_types().forEach(function(discounTypeContainer) {
    var distance_to_top = discounTypeContainer.getBoundingClientRect().top;

    if (distance_to_top <= 10 && distance_to_top >= -discounTypeContainer.offsetHeight) { // magic happens here
      active_title().innerHTML = discounTypeContainer.querySelector('.discount-type-title').innerHTML
    }
  })
}

// Replace low res images with high on image load
function replace_low_res_images_with_high_res() {
  document.querySelectorAll('.discount-img').forEach(function(img) {
    if (img.complete) {
      img.src = img.dataset.highSrc;
    } else {
      img.onload = function() {
        img.src = img.dataset.highSrc;
      }
    }
  });
}

// Modal logic
window.addEventListener('load', function(e) {
  var images = document.querySelectorAll('.discount-img');
  var modal = document.querySelector('#discount-img-modal');
  var modal_img = modal.querySelector('.modal-img');
  var modal_caption = modal.querySelector('.modal-caption');
  images.forEach(function(img) {
    img.addEventListener('click', function (e) {
      modal.style.display = 'flex';
      modal_img.setAttribute('src', img.src);
      modal_caption.innerHTML = img.alt
    });
  });

  modal.addEventListener('click', function(e) { modal.style.display = 'none'; });
})

// Add service worker
navigator.serviceWorker && navigator.serviceWorker.register('/service_worker.js')

// Callbacks
window.addEventListener('load', replace_low_res_images_with_high_res)

window.addEventListener('load', function(e) { active_title().innerHTML = first_title().innerHTML; })
window.addEventListener('scroll', replace_active_title)
