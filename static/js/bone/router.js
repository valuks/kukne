// Generated by CoffeeScript 1.3.3
(function() {
  var Router,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  App.Router = Router = (function(_super) {

    __extends(Router, _super);

    function Router() {
      return Router.__super__.constructor.apply(this, arguments);
    }

    Router.prototype.routes = {
      '': 'food',
      'food/:id': 'food'
    };

    Router.prototype.food = function(id) {
      var attributes, model,
        _this = this;
      if (id == null) {
        id = '';
      }
      if (!this._productsNavigation) {
        this._productsNavigation = new App.ViewProductsNavigation({
          collection: App.products
        });
        this._productsNavigation.render();
        $('#nav-products').append(this._productsNavigation.$el);
      }
      this._productsNavigation.deactivate();
      if (!this._foodNavigation) {
        this._foodNavigation = new App.ViewFoodsNavigation({
          collection: App.foods
        });
        this._foodNavigation.render();
        $('#nav-food').append(this._foodNavigation.$el);
      }
      if (this._food) {
        this._food.remove();
      }
      attributes = id ? App.foods.get(id).attributes : {};
      delete attributes['id'];
      model = new App.foods.model(attributes);
      this._productsNavigation.activate(model.products.pluck('product'));
      this._food = new App.ViewFood({
        model: model
      });
      this._food.appendEvent(this._food.model.products, 'remove', function(m) {
        return _this._productsNavigation.deactivate(m.get('product'));
      });
      this._food.render();
      $('#food').append(this._food.$el);
      this._food.appendEvent(this._productsNavigation, 'active', function(id) {
        return _this._food.model.addProduct({
          'product': id
        });
      });
      this._food.appendEvent(this._productsNavigation, 'deactive', function(id) {
        return _this._food.model.removeProduct(id);
      });
      return this._food.appendEvent(this._food, 'save', function() {
        App.foods.add(_this._food.model);
        _this._food.model.save();
        return _this.navigate('food/' + _this._food.model.id, {
          trigger: true
        });
      });
    };

    return Router;

  })(Backbone.Router);

}).call(this);
