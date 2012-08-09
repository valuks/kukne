
App.Router = class Router extends Backbone.Router
    routes: 
        '': 'index'
        'food/:id': 'food'


    food: (id='')->
        console.info 'food', id
        if not @_productsNavigation
            @_productsNavigation = new App.ViewProductsNavigation collection: App.products
            @_productsNavigation.render()
            $('#nav-products').append @_productsNavigation.$el
        if @_food
            @_food.remove()
        model = (if id then App.foods.get(id).clone() else new App.foods.model)
        @_food = new App.ViewFood model: model
        @_food.appendEvent @_food.model.products, 'remove', (m)=> @_productsNavigation.deactivate(m.get('product'))
        @_food.render()
        $('#food').append @_food.$el
        @_food.appendEvent @_productsNavigation, 'active', (id)=> @_food.model.addProduct({'product': id})
        @_food.appendEvent @_productsNavigation, 'deactive', (id)=> @_food.model.removeProduct(id)

    index: ->
        @food()