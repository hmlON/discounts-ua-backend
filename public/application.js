var active_title = document.querySelector('.active-title'),
    first_title = document.querySelector('.discount-type .discount-type-title'),
    discount_types = document.querySelectorAll('.discount-type');

active_title.innerHTML = first_title.innerHTML

window.onscroll = function() {
  discount_types.forEach(function(el) {
    var distance_to_top = el.getBoundingClientRect().top;

    if (distance_to_top <= 10 && distance_to_top >= -el.offsetHeight) { // magic happens here
      active_title.innerHTML = el.querySelector('.discount-type-title').innerHTML
    }
  })
}
