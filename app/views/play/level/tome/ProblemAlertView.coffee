CocoView = require 'views/kinds/CocoView'
template = require 'templates/play/level/tome/problem_alert'
{me} = require 'lib/auth'

module.exports = class ProblemAlertView extends CocoView
  className: 'problem-alert'
  template: template

  subscriptions: {}

  events:
    'click .close': 'onRemoveClicked'

  constructor: (options) ->
    super options
    @problem = options.problem

  getRenderData: (context={}) ->
    context = super context
    format = (s) -> s?.replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/\n/g, '<br>')
    context.message = format @problem.aetherProblem.message
    context.hint = format @problem.aetherProblem.hint
    context

  afterRender: ->
    super()
    @$el.addClass('alert').addClass("alert-#{@problem.aetherProblem.level}").hide().fadeIn('slow')
    @$el.addClass('no-hint') unless @problem.aetherProblem.hint
    Backbone.Mediator.publish 'audio-player:play-sound', trigger: 'error_appear', volume: 1.0

  onRemoveClicked: ->
    @$el.remove()
    @destroy()
    #@problem.destroy()  # let's try leaving the annotations / marker ranges alone
