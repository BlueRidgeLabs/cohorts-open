// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.

// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require fastclick/fastclick
//= require best_in_place
//= require holder
//= require jquery.validate
//= require jquery.validate.additional-methods
//= require moment/moment.min
//= require jquery-touchswipe/jquery.touchSwipe.min
//= require semantic_ui/semantic_ui
//= require trix
//= require maskedinput
//= require_tree ./admin
//= require_self

// Trix config
Trix.config.blockAttributes.heading1 = { tagName: "h2" }

$(document).on('ready page:load',function() {

  // Search filtering
  (function () {
    var $section = $("#filter-section"),
        $btn = $("#filter-button"),
        $form = $section.find("form"),
        $all = $form.find("#all"),
        $has_tags = $form.find("#has_tags"),
        $does_not_have_tags = $form.find("#does_not_have_tags"),
        $has_trait = $form.find("#has_trait"),
        $does_not_have_trait = $form.find("#does_not_have_trait"),
        $trait_value_equals = $form.find("#trait_value_equals"),
        $trait_value_doesnt_equal = $form.find("#trait_value_doesnt_equal"),
        $question = $form.find("#question"),
        $answer_equals = $form.find("#answer_equals"),
        $answer_does_not_equal = $form.find("#answer_does_not_equal"),
        $answer_contains = $form.find("#answer_contains"),
        $answer_does_not_contain = $form.find("#answer_does_not_contain"),
        $q = $form.find("#q");

    if ($section.length) {
      // Toggle filters section
      $btn.click(function () {
        $section.slideToggle("fast");
        return false;
      });

      $form.submit(function () {
        var all = $all.val(),
            has_tags = match_search_term("tag", $has_tags.val()),
            does_not_have_tags = match_search_term("-tag", $does_not_have_tags.val()),
            has_trait = $has_trait.val() ? "trait:(\"" + $has_trait.val() + ":" + $trait_value_equals.val() + "\")" : "",
            does_not_have_trait = $does_not_have_trait.val() ? "-trait:(\"" + $does_not_have_trait.val() + ":" + $trait_value_doesnt_equal.val() + "\")" : "",
            question = $question.val() ? ("question:(\"" + $question.val() + "\")") : "",
            answer_equals = match_search_term("answer", $answer_equals.val()),
            answer_does_not_equal = match_search_term("-answer", $answer_does_not_equal.val()),
            answer_contains = contain_search_term("answer", $answer_contains.val()),
            answer_does_not_contain = contain_search_term("-answer", $answer_does_not_contain.val()),
            query = [all, has_tags, does_not_have_tags, has_trait, does_not_have_trait, question, answer_equals, answer_does_not_equal, answer_contains, answer_does_not_contain].filter( function(v){ return v }).join(" ");

        $q.val(query);
      });

      function match_search_term(attr, val) {
        if (val && val.length) {
          var term = $.map(val, function (v) { return "\"" + v + "\""}).join(" || ");
          return attr + ":(" + term + ")";
        }
      }

      function contain_search_term(attr, val) {
        if (val && val.length) {
          var term = $.map(val, function (v) { return "*" + v.split(' ').join('?') + "*" }).join(" || ");
          return attr + ":(" + term + ")";
        }
      }
    }
  })();

  FastClick.attach(document.body);
  /* Activating Best In Place */
  jQuery(".best_in_place").best_in_place();


  var show_ajax_message = function(msg, type) {
    var cssClass = type === 'error' ? 'negative' : 'positive'
    var html ='<div class="ui message ' + cssClass + '">';
    html +='<i class="close icon"></i>';
    html += msg +'</div>';
    //fade_flash();
    $("#notifications").html(html);
    $('.ui.message .close').click(function() {
      $(this)
        .closest('.message')
        .transition('slide down');
    });
  };

  $(document).ajaxComplete(function(event, request) {
    var msg = request.getResponseHeader('X-Message');
    var type = request.getResponseHeader('X-Message-Type');

    if (type !== null) {
      show_ajax_message(msg, type);
    }
  });

  // Add active class to active menu items
  $('.ui.top.menu > a.item').each( function(index) {
    if (location.pathname.indexOf($(this).attr('href')) >= 0 && !$(this).hasClass('logo')) {
      $(this).addClass('active green');
      $(this).find('.label').addClass('green');
    }
  });
  $('.ui.tabular.menu > a.item').each( function(index) {
    if ($(this).attr('href') == location.pathname) {
      $(this).addClass('active');
    }
  });

  // Initialize Semantic elements
  var initializeDropdowns = function () {
    $('.ui.dropdown').dropdown({
      selectOnKeydown: false,
      forceSelection: false,
      fullTextSearch: true,
      onChange: function(value) {
        var target = $(this).parent();
        if(value) {
    	    target.find('.dropdown.icon').removeClass('dropdown').addClass('delete').on('click', function() {
            target.dropdown('clear');
            $(this).removeClass('delete').addClass('dropdown');
          });
        }
      }
    });
    $('.ui.no-clear.dropdown').dropdown({
      selectOnKeydown: false,
      forceSelection: false,
      fullTextSearch: true
    });
    // Some searches shouldn't be fuzzy
    $('.ui.non-fuzzy.dropdown').dropdown({
      selectOnKeydown: false,
      forceSelection: false,
      fullTextSearch: 'exact',
      onChange: function(value) {
        var target = $(this).parent();
        if(value) {
    	    target.find('.dropdown.icon').removeClass('dropdown').addClass('delete').on('click', function() {
            target.dropdown('clear');
            $(this).removeClass('delete').addClass('dropdown');
          });
        }
      }
    });
    // Allow additions to some dropdowns
    $('.ui.dropdown.allow-addition').dropdown({
      selectOnKeydown: false,
      forceSelection: false,
      fullTextSearch: true,
      allowAdditions: true,
      hideAdditions: false,
      onChange: function(value, text, $choice) {
        var target = $(this);
        if(value) {
          target.find('.dropdown.icon').removeClass('dropdown').addClass('delete').on('click', function() {
            target.dropdown('clear');
            $(this).removeClass('delete').addClass('dropdown');
          });

          // Automatically submit new tags
          if($(this).hasClass("auto-add") && $choice.hasClass('addition')) {
            $(this).submit();
          }
        }
      }
    });
    // Remote answer dropdown
    $('.ui.remote-answers.dropdown').dropdown({
      selectOnKeydown: false,
      forceSelection: false,
      fullTextSearch: 'exact',
      apiSettings: {
        url: '/admin/questions/{id}.json',
        beforeSend: function(settings) {
          settings.urlData = {
            id: $('#filter-section select#question').val()
          };
          return settings;
        }
      }
    });
    // Remote question choices dropdown
    $('.ui.remote-choices.dropdown').dropdown({
      selectOnKeydown: false,
      forceSelection: false,
      fullTextSearch: true,
      allowAdditions: true,
      hideAdditions: false,
      apiSettings: {
        url: '/admin/questions/{id}/choices.json',
        beforeSend: function(settings) {
          settings.urlData = {
            id: $('#filter-section select#question').val()
          };
          return settings;
        }
      },
      onChange: function(value, text, $choice) {
        var target = $(this);
        if(value) {
          target.find('.dropdown.icon').removeClass('dropdown').addClass('delete').on('click', function() {
            target.dropdown('clear');
            $(this).removeClass('delete').addClass('dropdown');
          });

          // Automatically submit new tags
          if($(this).hasClass("auto-add") && $choice.hasClass('addition')) {
            $(this).submit();
          }
        }
      }
    });
  }
  initializeDropdowns();
  $('.ui.menu .ui.dropdown').dropdown();
  $('.ui.checkbox').checkbox();
  $('.ui.calendar:not(.datetime)').calendar({
    type: 'date'
  });
  $('.ui.calendar.range-end').each(function() {
    rangeStart = $(this).parent().prev().find('.ui.calendar.range-start')
    $(this).calendar({
      type: 'date',
      startCalendar: rangeStart
    });
  });
  $('.ui.datetime.calendar').calendar();
  $('.sortable.table').tablesort();
  $('.tooltippy').popup();
  $('.ui.modal').modal({onShow: function () {
    initializeDropdowns();
    $('.ui.modal .ui.calendar').calendar({
      type: 'date'
    });
    $('.ui.calendar.range-end').each(function() {
      rangeStart = $(this).parent().prev().find('.ui.calendar.range-start')
      $(this).calendar({
        type: 'date',
        startCalendar: rangeStart
      });
    });
    $('.ui.datetime.calendar').calendar();
  }});

  // Inbox tabs
  $('#message-tab-menu .item').tab({
    // auto: true,
    cache: false,
    apiSettings: {
      url: 'https://' + location.host + '/admin/inbox/{person_id}',
      dataType: 'html',
      beforeSend: function(settings) {
        settings.urlData = {
          person_id: $(this).attr('data-tab')
        };
        return settings;
      },
      onSuccess: function(response) {
        tab_id = '#' + $(this).attr('data-tab') + '-tab-content';
        $(tab_id).html(response);
      }
    },
    onLoad: function() {
      $tab_id = $('#' + $(this).attr('data-tab') + '-tab-content');
      $comments = document.getElementById('inbox-message-container');
      $comments.scrollTop = $comments.scrollHeight;
      $tab_id.find('.ui.dropdown').dropdown();
      $tab_id.find('.ui.submit.button').click(function() {
        $(this).parents('form').submit();
      });
      $tab_id.find('#send-method').change(function(e) {
        if (e.target.value === 'Email') {
          $('#sms-reply-form').hide();
          $('#email-reply-form').show();
        } else {
          $('#email-reply-form').hide();
          $('#sms-reply-form').show();
        }
      });
    }
  });
  $('#message-tab-menu .active.item').click();

  // Turn file input into a button
  $('.hidden-file-field').hide();
  $('.fake-file-field').click(function(e) {
    $("input[type='file']").click();
  });
  $('.hidden-file-field').change(function() {
    $('.button-text').text(
      $('input[type=file]').val().split('\\').pop()
    );
  });

  // Close alerts
  $('.ui.message .close').click(function() {
    $(this)
      .closest('.message')
      .transition('slide down');
  });

  // Submit button hack
  $('.ui.submit.button').click(function() {
    $(this).parents('form').submit();
  });
  $('.ui.modal .ui.submit.button').click(function() {
    $(this).parents('.modal').find('form').submit();
  });
  $('.ui.card .ui.submit.button').click(function() {
    $(this).parents('.card').find('form').submit();
  });
  $('.search.link.icon').click(function() {
    if ($(this).prev().val() === '') {
      window.location.pathname = '/admin/members'
    } else {
      $(this).parents('form').submit();
    }
  });

  // Modals
  $('.modal-show').click(function() {
    modalId = $(this).attr('id');
    $('.ui.modal#' + modalId).modal('show');
  });

  // Privacy mode toggle
  $('#privacy-mode-toggle').checkbox({
    onChange: function() {
      window.location.pathname = '/admin/privacy_mode'
    }
  });
  $('.checked#privacy-mode-toggle').checkbox('set checked');

  // Person trait editing
  $('#update-person-trait-form').hide();
  $('#trait-list .pencil.icon').click(function() {
    trait_id = $(this).parents('.ui.label').attr('data-trait-id');
    person_id = $(this).parents('.ui.label').attr('data-person-id');
    action = '/admin/members/' + person_id + '/traits/' + trait_id;
    $('#update-person-trait-form').attr('action', action);
    trait_name = $(this).parents('.ui.label').find('.trait-name').text();
    $('#update-person-trait-form .ui.dropdown').dropdown('set selected', trait_name);
    trait_value = $(this).parents('.ui.label').find('.trait-value').text();
    $('#update-person-trait-form #person_trait_value').val(trait_value);
    $(this).parents('.ui.label').transition('scale').remove();
    $('#update-person-trait-form').transition('slide down');
  });

  // Comment editing
  $('.comment .pencil.icon').click(function() {
    $comment = $(this).parents('.content').find('.text');
    text = $comment.attr('data-comment-content');
    action = $comment.attr('data-edit-action');
    $comment.empty();
    $comment
      .append('<form class="edit-comment-form ui form" data-remote="true"></form>');
    $comment.find('.edit-comment-form')
      .attr('action', action).attr('method', 'put')
      .append('<div class="field"><div class="ui fluid action input"><input type="text" name="comment[content]" id="comment_content"><div class="ui green submit button" type="submit"><i class="edit icon"></i>Update</div></div></div>')
    $comment.find('#comment_content').val(text);
    $comment.find('.ui.submit.button').click(function() {
      $(this).parents('form').submit();
    });
  });

  // Contact editing
  $('.comment .pencil.icon').click(function () {
    $contact = $(this).parents('.notes').find('.text');
    text = $contact.attr('data-contact-notes');
    action = $contact.attr('data-edit-action');
    $contact.empty();
    $contact
      .append('<form class="edit-contact-form ui form" data-remote="true"></form>');
    $contact.find('.edit-contact-form')
      .attr('action', action).attr('method', 'put')
      .append('<div class="field"><div class="ui fluid action input"><input type="text" name="contact[notes]" id="contact_notes"><div class="ui green submit button" type="submit"><i class="edit icon"></i>Update</div></div></div>')
    $contact.find('#contact_notes').val(text);
    $contact.find('.ui.submit.button').click(function () {
      $(this).parents('form').submit();
    });
  });

  // Answer editing
  $('.answer-value-cell .pencil.icon').click(function() {
    $value = $(this).parents('.answer-value-cell').find('.answer-value');
    text = $value.attr('data-value-content');
    action = $value.attr('data-edit-action');
    form_html = $value.attr('data-edit-form-html');
    $value.empty();
    $(this).remove();
    $value
      .append('<form class="edit-answer-value-form ui form" data-remote="true"></form>');
    $value.find('.edit-answer-value-form')
      .attr('action', action).attr('method', 'put')
      .append(form_html)
    initializeDropdowns();
    $value.find('#value_content').val(text);
    $value.find('.ui.submit.button').click(function() {
      $(this).parents('form').submit();
    });
  });

  // Clockpicker
  $('.clockpicker').clockpicker({
    donetext: 'Select',
    twelvehour: true
  });

  // Saved searches and bulk tag popups
  $('.popup-button').popup({
    on: 'click',
    position: 'bottom right'
  });

  // Engagement eligible member filtering
  if (location.search.match(/filter/)) {
    $('#filter-section').show();
  }
});
