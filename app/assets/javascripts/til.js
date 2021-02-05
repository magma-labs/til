$(function(){

  $(document.body).on("click", "#flash p", function(e) {
    e.preventDefault();
    $(this).fadeOut(200);
  });

  $(".site_nav__search, .site_nav__about").on("click", ".site_nav__link", function(e) {
    e.preventDefault();
    $(this).closest('li')
      .toggleClass('site_nav--open')
      .find(":input:visible").eq(0).focus();
    e.stopPropagation();
  });

  $(document.body).on('click', function (e) {
    var $about = $('.site_nav__about')
    var _opened = $about.hasClass('site_nav--open');
    if (_opened === true) {
      $about.toggleClass('site_nav--open');
      e.stopPropagation();
    }
  });

  $(document.body).on('click', function (e) {
    var $search = $('.site_nav__search');
    var _opened = $search.hasClass('site_nav--open');
    if (_opened === true) {
      $search.toggleClass('site_nav--open');
      e.stopPropagation();
    }
  });

  $('.post').syntaxLabel();

  setTimeout(function () {
      $('#flash').remove();
    }, 3000);
});
