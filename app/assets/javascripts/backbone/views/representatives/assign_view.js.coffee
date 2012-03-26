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
    rep = @reps.get(rep_id)
    @territory.setRep(rep)
    @territory.save(null,
      success : () =>
        @parentView.rerender()
        $(@el).modal('hide')
        @remove()
    )

  render : ->
    $(@el).html(@template(@territory.toJSON() ))
    reps = new Mapbadger.Views.Representatives.IndexView(collection: @reps)
    @$("select#available-reps").replaceWith(reps.render().el)
    if @territory.rep?
      @$("select#available-reps").val(@territory.rep.id).attr('selected', 'selected')

    return this
