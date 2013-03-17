/* Place all the behaviors and hooks related to the matching controller here.
 * All this logic will automatically be available in application.js.
 */

$(document).ready(function() {
  $("a.slowscroll").live('click', function() {
      var id = $(this).attr('href');
      $('html,body').animate({scrollTop: $(id).offset().top}, 'slow', 'swing');
      return false;
  });

  $("a.opensignupform").live('click', function() {
    $('#signupFormContainer').collapse('show');
    $('input#company').focus();
  });
});

$(document).ready(function() {

  $('.signupform')
    .bind("ajax:beforeSend", function(evt, xhr, settings) {
      if ($("input,select,textarea").not("[type=submit]").jqBootstrapValidation("hasErrors")) {
        xhr.abort();
        return false;
      }
    })
    .bind("ajax:success", function(evt, data, status, xhr) {
      var $form = $(this);
      if (data.error) {
        var length = data.errors.length, element = null, message = "";
        for (var i = 0; i < length; i++) {
          element = data.errors[i];
          message += "- " + element + "\n";
        }
        alert("There were errors on the form, please review and correct.\n\n" + message);
      } else {
        alert("Thank you! we'll notify you the minute we open the doors!");
        $('#signupFormContainer').collapse('hide');
        $('#signupform')[0].reset();
      }
    })
    .bind('ajax:error', function(evt, xhr, status, error) {
      alert("There was a problem trying to save your data. Please try again.");
    });


  $("input,select,textarea").not("[type=submit]").jqBootstrapValidation({
    preventSubmit: true,
    submitError: function ($form, event, errors) {
      console.log(errors);
    }
  });

});
