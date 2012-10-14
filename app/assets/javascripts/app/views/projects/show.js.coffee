App.Projects.Show = Backbone.View.extend
  el: "body"

  events:
    "click .btn-download" : "submitForm"
    "submit form" : "closeModal"

  initialize: ->
    _.bindAll(this)

  closeModal: ->
    $('#download-messges').modal('hide')

  submitForm: ->
    @closeModal()
    $('form').submit()

