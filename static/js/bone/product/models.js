// Generated by CoffeeScript 1.3.3
(function() {
  var Categories, Category, Product, Products,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Product = (function(_super) {

    __extends(Product, _super);

    function Product() {
      return Product.__super__.constructor.apply(this, arguments);
    }

    Product.prototype.initialize = function() {
      this.category = this.collection.category;
      return this.set({
        'category': this.category.id
      });
    };

    return Product;

  })(Backbone.Model);

  Products = (function(_super) {

    __extends(Products, _super);

    function Products() {
      return Products.__super__.constructor.apply(this, arguments);
    }

    Products.prototype.model = Product;

    Products.prototype.initialize = function(models, pr) {
      return this.category = pr.category;
    };

    return Products;

  })(Backbone.Collection);

  Category = (function(_super) {

    __extends(Category, _super);

    function Category() {
      return Category.__super__.constructor.apply(this, arguments);
    }

    Category.prototype.initialize = function(properties) {
      return this.products = new Products(properties.products, {
        category: this
      });
    };

    return Category;

  })(Backbone.Model);

  App.CollectionProducts = Categories = (function(_super) {

    __extends(Categories, _super);

    function Categories() {
      return Categories.__super__.constructor.apply(this, arguments);
    }

    Categories.prototype.model = Category;

    Categories.prototype.byId = function(id) {
      var m, _i, _len, _ref;
      _ref = this.models;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        m = _ref[_i];
        if (m.products.get(id)) {
          return m.products.get(id);
        }
      }
    };

    return Categories;

  })(Backbone.Collection);

}).call(this);
