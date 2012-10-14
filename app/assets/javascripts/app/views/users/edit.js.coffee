App.Users.Registrations.Edit = App.Users.Registrations.Update = Backbone.View.extend
  el: "body"

  events:
    "click .btn-user-update" : "submitForm"

  initialize: ->
    _.bindAll(this)

  submitForm: ->
    $('form').submit()
    false

