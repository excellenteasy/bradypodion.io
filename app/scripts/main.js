$(function(){
  $('a[href*=#]:not([href=#])').click(function() {
    if (location.pathname.replace(/^\//,'') == this.pathname.replace(/^\//,'')
        || location.hostname == this.hostname) {

    var target = $(this.hash);
    target = target.length ? target : $('[name=' + this.hash.slice(1) +']');
    if (target.length) {
      $('html,body').animate({
         scrollTop: target.offset().top
      }, 1000);
      if (window.history != null && window.history.pushState != null) {
        window.history.pushState({},null,this.hash);
      }
      return false;
    }
  }
});

  $('#onthelist').click(function(){
    setTimeout(function(){
      $('#mce-EMAIL').focus();
    },1000);
  });

  $('.videowrapper iframe').each(function(i,iframe){
    $iframe = $(iframe);
    src = $iframe.attr('data-src');
    $iframe.attr('src',src);
  });
});
