// Header with discount type login
var active_title = document.querySelector('.active-title'),
    first_title = document.querySelector('.discount-type .discount-type-title'),
    discount_types = document.querySelectorAll('.discount-type');

active_title.innerHTML = first_title.innerHTML

window.onscroll = function() {
  discount_types.forEach(function(discounTypeContainer) {
    var distance_to_top = discounTypeContainer.getBoundingClientRect().top;

    if (distance_to_top <= 10 && distance_to_top >= -discounTypeContainer.offsetHeight) { // magic happens here
      active_title.innerHTML = discounTypeContainer.querySelector('.discount-type-title').innerHTML
    }
  })
}

// Replace low res images with high on image load
document.querySelectorAll('.discount-img').forEach(function(img) {
  if (img.complete) {
    img.src = img.dataset.highSrc;
  } else {
    img.onload = function() {
      img.src = img.dataset.highSrc;
    }
  }
});

// Modal logic
var images = document.querySelectorAll('.discount-img'),
    modal = document.querySelector('#discount-img-modal'),
    modal_img = modal.querySelector('.modal-img'),
    modal_caption = modal.querySelector('.modal-caption');
images.forEach(function(img) {
  img.addEventListener('click', function (e) {
    modal.style.display = 'flex';
    modal_img.setAttribute('src', img.src);
    modal_caption.innerHTML = img.alt
  });
});

modal.addEventListener('click', function(e) {
  modal.style.display = 'none';
});

// Add service worker
navigator.serviceWorker && navigator.serviceWorker.register('/service_worker.js')
