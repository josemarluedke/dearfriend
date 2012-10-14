App.Messages.SelectProject = App.Messages.Update = Backbone.View.extend
  el: "body"

  events:
    "submit form": "submitForm"
    "click .btn-choose": "choose"
    "click .btn-selected": "selected"

  initialize: ->
    _.bindAll(this)
    @project_id = $('#message_project_id')

  submitForm: ->
    if @project_id.val() == ''
      alert 'Please, select a Dear Friend.'
      false

  choose: (event)->
    target = $(event.target)
    @project_id.val(target.data('id'))
    $('.btn-selected').hide()
    $('.btn-choose').show()
    $('.project-'+target.data('id')).find('.btn-choose').hide()
    $('.project-'+target.data('id')).find('.btn-selected').fadeIn()
    false

  selected: (event)->
    target = $(event.target)
    @project_id.val()
    $('.btn-selected').hide()
    $('.project-'+target.data('id')).find('.btn-choose').fadeIn()
    false
