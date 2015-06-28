EventBus = ->

  listeners = {}

  dispatch = (event, data...)->
    check event, String

    actions = listeners[event]

    if actions? and actions.length > 0
      actions.forEach (fn) ->
        fn.apply(null, data)

  addListener = (event, fn) ->
    check event, String
    check fn, Function

    actions = listeners[event] || []
    actions.push(fn)
    listeners[event] = actions

  removeListener = (event, listener) ->
    check event, String
    check listener, Match.Optional(Function)

    if listeners[event]?

      if listener
        actions = listeners[event]
        if actions? and actions.length > 0
          index = actions.indexOf(listener)
          if index > -1
            actions.splice(index, 1)
      else
        delete listeners[event]

  # Public API

  # Aliases ...
  dispatch: dispatch
  add: dispatch
  send: dispatch
  emit: dispatch
  trigger: dispatch

  register: addListener
  on: addListener

  off: removeListener
  deregister: removeListener
  remove: removeListener
