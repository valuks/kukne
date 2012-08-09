App.ViewProductsNavigation = class Products extends Backbone.View
	tagName: "ul"
	className: 'nav-products'
	_active: []
	template: _.template """
		<% this.collection.each(function(m){ %>
			<li><span><%= m.get('name') %></span><i class="badge"></i>
				<ul>
					<% m.products.each(function(p){%>
						<li data-pk='<%= p.id %>'><span><%= p.get('name') %></span></li>	
					<%})%>
				</ul>
			</li>
		<%})%>
	"""
	events: 
		'click ul>li>span': (e)-> $(e.currentTarget).closest('li').toggleClass('open')
		'click ul>li>ul>li>span': 'toggleActive'

	active: -> @_active

	updateCounter: ->
		@$el.find('>li>ul').each ()->
			total = $(this).find('.active').length
			$(this).closest('li').find('>i').html(if total>0 then total else '')

	activate: (id, silent=false)->
		if _.isArray(id)
			return _.each id, (id)=> @activate(id, true)
		@_active.push id
		@$el.find('li[data-pk="'+id+'"]').addClass('active')
		@updateCounter()
		@trigger 'active', id if not silent

	deactivate: (id, silent=false)->
		if not id
			return _.each _.clone(@_active), (id)=> @deactivate(id, true)
		@_active.splice _.indexOf(@_active, id), 1
		@$el.find('li[data-pk="'+id+'"]').removeClass('active')
		@updateCounter()
		@trigger 'deactive', id if not silent

	toggleActive: (e)->
		id = parseInt($(e.currentTarget).closest('li').attr('data-pk'))
		if id in @_active
			@deactivate(id)
		else
			@activate(id)