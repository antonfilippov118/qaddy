/* Place all the behaviors and hooks related to the matching controller here.
 * All this logic will automatically be available in application.js.
 */

$(document).ready(function() {
  $('body').on('click', 'a.slowscroll', function() {
      var id = $(this).attr('href');
      $('html,body').animate({scrollTop: $(id).offset().top}, 'slow', 'swing');
      return false;
  });

  $('body').on('click', 'a.opensignupform', function() {
    $('#signupFormContainer').collapse('show');
    $('input#company').focus();
  });
});

$(document).ready(function() {
  $('.signupform').find('.alert .close').on('click', function(e) {
    $(this).parent().removeClass("in");
    $(this).parent().addClass("hidden");
  });

  $('.signupform')
    .bind("ajax:beforeSend", function(evt, xhr, settings) {
    })
    .bind("ajax:success", function(evt, data, status, xhr) {
      $('#signupFormContainer').collapse('hide');
      $('#signupform')[0].reset();

      // alert("Thank you! we'll notify you the minute we open the doors!");
      $('#successModal').modal({
        backdrop: true,
        keyboard: false
      });
    })
    .bind('ajax:error', function(evt, xhr, status, error) {
      var responseObject = $.parseJSON(xhr.responseText), errors = $('<ul />');
      $.each(responseObject.errors, function(index, value) {
        errors.append('<li>' + value + '</li>');
      })
      $(this).find('.errors').html(errors);
      $(this).find('.alert').addClass("in");
      $(this).find('.alert').removeClass("hidden");
    });


});
