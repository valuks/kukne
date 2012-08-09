
App.Router = class Router extends Backbone.Router
    routes: 
        '': 'food'
        'food/:id': 'food'


    food: (id='')->
        # console.info 'food', id, App.foods
        if not @_productsNavigation
            @_productsNavigation = new App.ViewProductsNavigation collection: App.products
            @_productsNavigation.render()
            $('#nav-products').append @_productsNavigation.$el
        @_productsNavigation.deactivate()
        if not @_foodNavigation
            @_foodNavigation = new App.ViewFoodsNavigation collection: App.foods
            @_foodNavigation.render()
            $('#nav-food').append @_foodNavigation.$el
        if @_food
            @_food.remove()
        attributes = if id then App.foods.get(id).attributes else {}
        delete attributes['id']
        model = new App.foods.model attributes
        @_productsNavigation.activate(model.products.pluck('product'))
        @_food = new App.ViewFood model: model
        @_food.appendEvent @_food.model.products, 'remove', (m)=> @_productsNavigation.deactivate(m.get('product'))
        @_food.render()
        $('#food').append @_food.$el
        @_food.appendEvent @_productsNavigation, 'active', (id)=> @_food.model.addProduct({'product': id})
        @_food.appendEvent @_productsNavigation, 'deactive', (id)=> @_food.model.removeProduct(id)
        @_food.appendEvent @_food, 'save', =>
            App.foods.add @_food.model
            @_food.model.save()
            @navigate('food/'+@_food.model.id, trigger: true)
