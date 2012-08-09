class Product extends Backbone.Model
	defaults:
		weight: 0

	initialize: ()->
		@food = @collection.food
		@product = App.products.byId(@get('product'))
		@set({'food': @food.id})

	_calculate: (v)-> @product.get(v) * @get('weight')/100

	calories: -> @_calculate('calories')
	protein: -> @_calculate('protein')
	hydrates: -> @_calculate('hydrates')
	fat: -> @_calculate('fat')
	cholesterol: -> @_calculate('cholesterol')


class Products extends Backbone.Collection
	model: Product
	initialize: (models, pr)->
		@food = pr.food


class Food extends Backbone.Model
	initialize: (properties)->
		@products = new Products (if properties and properties.products then properties.products else []), food: @
		@products.on 'all', =>
			@set 'products': @products.map (p)-> {'product': p.get('product'), 'weight': p.get('weight')}

	addProduct: (params)-> @products.add params

	removeProduct: (id)-> _.each @products.where({'product': id}), (m)-> m.destroy()

	_calculate: (v)->
		@products.reduce(((memo, m)-> memo + m[v]()), 0)

	calories: -> @_calculate('calories')
	protein: -> @_calculate('protein')
	hydrates: -> @_calculate('hydrates')
	fat: -> @_calculate('fat')
	cholesterol: -> @_calculate('cholesterol')

	weight: -> @products.reduce(((memo, m)-> memo + m.get('weight')), 0)



App.CollectionFoods = class Foods extends Backbone.Collection
	# localStorage: new Store("foods")

	model: Food
