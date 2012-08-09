class Product extends Backbone.Model
	initialize: ()->
		@category = @collection.category
		@set({'category': @category.id})

class Products extends Backbone.Collection
	model: Product
	initialize: (models, pr)->
		@category = pr.category


class Category extends Backbone.Model
	initialize: (properties)->
		@products = new Products properties.products, category: @


App.CollectionProducts = class Categories extends Backbone.Collection
	model: Category

	byId: (id)->
		for m in @models
			if m.products.get(id)
				return m.products.get(id)

