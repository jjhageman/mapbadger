Mapbadger.Views.Representatives ||= {}

class Mapbadger.Views.Representatives.AssignView extends Backbone.View
  template: JST["backbone/templates/representatives/assign"]
  id: "assign-rep-form"
  className: "modal hide fade"

  events :
    "submit #assign-representative": "assign"

  initialize: ->
    @territory = @options.territory
    @reps = @options.reps
    @parentView = @options.parent

  assign: (e) ->
    e.preventDefault()
    e.stopPropagation()

    @territory.unset("errors")

    rep_id = $('select#available-reps option:selected').val()
    if rep_id?
      rep = @reps.get(rep_id)
      @territory.setRep(rep)
      @territory.save(null,
        success : () =>
          $(@el).modal('hide')
          @remove()
          @parentView.rerender()
        error: (model, fail, xhr) =>
           @$('.modal-body').prepend('<div class="alert alert-error"><strong>Error:</strong>'+fail+'</div>')
      )
    else
      @$('.modal-body').prepend('<div class="alert alert-error"><strong>Error:</strong> Please select a representative.</div>')
      @$('.alert-error').fadeIn()


  render : ->
    $(@el).html(@template(@territory.toJSON() ))
    reps = new Mapbadger.Views.Representatives.IndexView(collection: @reps)
    @$("select#available-reps").replaceWith(reps.render().el)
    if @territory.rep?
      @$("select#available-reps").val(@territory.rep.id).attr('selected', 'selected')

    return this
