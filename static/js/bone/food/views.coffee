App.ViewFoodsNavigation = class Foods extends Backbone.View
	tagName: 'ul'
	className: 'nav-foods'
	template: _.template """
		<% this.collection.each(function(m){ %>
			<li data-pk='<%= m.id %>'><a href='#food/<%= m.id %>'><%= m.get('name') %></a> <span class='delete'></span></li>
		<%})%>
	"""

	events:
		'click .delete': (e)-> @collection.get($(e.target).closest('li').attr('data-pk')).destroy() 

	initialize: ->
		@appendEvent @collection, 'all', ()=>
			@$el.empty()
			@render()


App.ViewFood = class Food extends Backbone.View
	template: _.template """
		<h1><%= this.model.get('name') || '' %></h1>
		<table class='table table-condensed'>
			<thead>
				<tr>
					<th><%= _l('Title') %></th>
					<th><%= _l('Weight') %></th>
					<th><%= _l('Calories') %></th>
					<th><%= _l('Protein') %></th>
					<th><%= _l('Hydrates') %></th>
					<th><%= _l('Fat') %></th>
					<th><%= _l('Cholesterol') %></th>
					<th></th>
				</tr>
			</thead>
			<tbody>
			</tbody>
			<tfoot>
				<tr>
					<td></td>
					<td class='product-total-weight'></td>
					<td class='product-total-calories'></td>
					<td class='product-total-protein'></td>
					<td class='product-total-hydrates'></td>
					<td class='product-total-fat'></td>
					<td class='product-total-cholesterol'></td>
					<td></td>
				</tr>
			</tfoot>
		</table>
		<div class="form-actions">
			<div class="input-append">
				<input type='text' value='<%= this.getNewName() %>' />
				<button class="btn btn-primary" type="submit"><%= _l('Save changes') %></button>
			</div>
		</div>
	"""

	events: 
		'keypress .form-actions input': (e)-> @save() if e.keyCode is 13

		'click .form-actions button': 'save'
			
	initialize: ->
		@appendEvent @model.products, 'add', (m)=> @_addProduct(m)
		@appendEvent @model.products, 'remove', (m)=> @_removeProduct(m)
		@appendEvent @model.products, 'all', (m)=> @update()

	save: ->
		@model.set({'name': @$('.form-actions input').val()})
		@trigger 'save'


	getNewName: ->
		name = this.model.get('name') || ''
		if name == ''
			return ''
		match = /(.+) \(([0-9]+)\)/.exec(name)
		n = if match then match[1] else name
		c = if match then parseInt(match[2]) else 0
		n + ' (' + (c + 1) + ')'

	update: ->
		for p in ['weight', 'calories', 'protein', 'hydrates', 'fat', 'cholesterol']
			@$(".product-total-#{p}").html(@model[p]().toFixed())

	_addProduct: (m)->
		pr = new FoodProduct model: m
		@appendSubView(pr)
		pr.render()
		m.prView = pr
		@tbody.append pr.$el

	_removeProduct: (m)-> m.prView.remove()


	render: ->
		super
		@tbody = @$('tbody')
		@update()
		form_actions = @$('.form-actions')
		form_actions.css('display', 'none')
		@appendEvent @model, 'change', _.once -> form_actions.css('display', '')
		@model.products.each (m)=> @_addProduct(m)


class FoodProduct extends Backbone.View
	tagName: 'tr'
	template: _.template """
		<td><%= this.model.product.get('name') %></td>
		<td><input type='text' value='<%= this.model.get('weight') %>' /></td>
		<td class='product-calories'></td>
		<td class='product-protein'></td>
		<td class='product-hydrates'></td>
		<td class='product-fat'></td>
		<td class='product-cholesterol'></td>
		<td><span class='delete'></span></td>
	"""

	events:
		'click .delete': ->
			@model.destroy()
		'keyup input': ->
			v = @$('input').attr('value').replace(',', '.')
			if new RegExp('^[0-9,.]+$').test(v) then @$('input').removeClass('error') else @$('input').addClass('error')
			@model.set weight: parseFloat(v)

	initialize: ->
		@appendEvent @model, 'all', => @update()
		@appendEvent @model, 'destroy', => @remove()
	
	update: ->
		for p in ['calories', 'protein', 'hydrates', 'fat', 'cholesterol']
			@$(".product-#{p}").html(@model[p]().toFixed())

	render: ->
		super
		@update()


