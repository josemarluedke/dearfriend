App.Projects.Show = Backbone.View.extend
  el: "body"

  events:
    "click .btn-download" : "closeModal"

  initialize: ->
    _.bindAll(this)

  closeModal: ->
    $('#download-messges').modal('hide')
