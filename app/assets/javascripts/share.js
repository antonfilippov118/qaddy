//= require jquery
//= require jquery_ujs
//= require bootstrap

var fbLoggedIn = false;

$(document).ready(function() {
  var isAnyShared = false;

  $('.shareform')
    .bind("ajax:beforeSend", function(evt, xhr, settings) {
      if (!fbLoggedIn) {
        authUser();
        return false;
      }
      var $form = $(this);
      var btn = $form.find('.sharebtn');
      btn.val(btn.data('sharingtext'));
      btn.addClass('disabled');
      btn.attr('disabled','disabled');
    })
    .bind("ajax:success", function(evt, data, status, xhr) {
      var $form = $(this);
      var btn = $form.find('.sharebtn');
      btn.data('isshared', true);
    })
    .bind('ajax:error', function(evt, xhr, status, error) {
      alert("There was a problem sharing this item. Please try again.");
    })
    .bind('ajax:complete', function(evt, xhr, status) {
      var $form = $(this);
      var btn = $form.find('.sharebtn');

      if (btn.data('isshared')) {
        btn.val(btn.data('sharedtext'));
        btn.addClass('disabled');
        btn.attr('disabled','disabled');

        if (!isAnyShared) {
          isAnyShared = true;
          $('#successModal').modal({
            backdrop: true,
            keyboard: false
          });
        }
      } else {
        btn.val(btn.data('sharetext'));
        btn.removeClass('disabled');
        btn.removeAttr('disabled');
      }
    });
});

function authUser() {
  if (fbLoggedIn) {
    FB.logout(checkLoginStatus);
  } else {
    FB.login(checkLoginStatus, {scope:'email, publish_stream', redirect_uri: "<%= @redirect %>"/*, display : 'touch'*/});
  }
}

function checkLoginStatus(response) {
  $('#login').removeClass('disabled');
  $('#login').removeAttr('disabled');

  if (response && response.status == 'connected') {
    fbLoggedIn = true;

    var loginBtnTxt = $('#login').data('logouttext');
    $('#login').text(loginBtnTxt);
    $('#logout').removeClass('hide');
    $('.loginrow').addClass('hide');

    $('.sharebtn').each(function(index, obj) {
      $(this).val($(this).data('sharetext'));
    });
    $('.sharebtn').removeClass('disabled');
    $('.sharebtn').removeAttr('disabled');
  } else {
    fbLoggedIn = false;

    var txt = $('#login').data('logintext');
    $('#login').text(txt);
    $('#logout').addClass('hide');
    $('.loginrow').removeClass('hide');

    $('.sharebtn').each(function(index, obj) {
      $(this).val($(this).data('logintext'));
    });
    $('.sharebtn').removeClass('disabled');
    $('.sharebtn').removeAttr('disabled');
  }
}

