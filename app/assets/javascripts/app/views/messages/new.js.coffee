App.Messages.New = App.Messages.Create = Backbone.View.extend
  el: "body"

  events:
    "click .btn-send-message" : "submitForm"

  initialize: ->
    _.bindAll(this)

  submitForm: ->
    $('form').submit()
    false

