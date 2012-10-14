App.Messages.SelectProject = App.Messages.Update = Backbone.View.extend
  initialize: ->
    _.bindAll(this)
    $('form').bind('submit', @submitForm)
    $('.btn-choose').bind('click', @choose)
    $('.btn-selected').bind('click', @selected)
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
