App = window.App =
  Common:
    initPage: ->
      # If you are using the Turbolinks and you need run a code only one time, put something here.
      # if you're not using the turbolinks, there's no difference between init and initPage.
    init: ->
      @flash()

    finish: ->
      # Something here. This is called in every page, with or without Turbolinks.

    flash: ->
      setTimeout (->
        $(".flash").slideDown "slow"
      ), 100
      unless $(".flash a").length
        setTimeout (->
          $(".flash").slideUp "slow"
        ), 10000
      $(window).click ->
        $(".flash").slideUp()

  Messages: {}
  Projects: {}
  Users:
    Registrations: {}