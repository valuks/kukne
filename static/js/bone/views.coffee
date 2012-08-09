class Backbone.View extends Backbone.View

	render: -> @$el.append @template this: @

	appendEvent: (obj, event, callback)->
		@__events = [] if not @__events
		obj.bind(event, callback)
		@__events.push
			on: obj
			event: event
			callback: callback

	appendSubView: (v)->
		@__subview = [] if not @__subview
		@__subview.push(v)

	__unbind: ->
		if @__events
			while event = @__events.shift()
				event['on'].off(event['event'], event['callback'])

	__cleanup: ->
		if @__subview
			while view = @__subview.shift()
				view.remove()

	remove: ->
		@__unbind()
		@__cleanup()
		super