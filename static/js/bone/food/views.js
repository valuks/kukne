// Generated by CoffeeScript 1.3.3
(function() {
  var Food, FoodProduct, Foods,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  App.ViewFoodsNavigation = Foods = (function(_super) {

    __extends(Foods, _super);

    function Foods() {
      return Foods.__super__.constructor.apply(this, arguments);
    }

    Foods.prototype.tagName = 'ul';

    Foods.prototype.className = 'nav-foods';

    Foods.prototype.template = _.template("<% this.collection.each(function(m){ %>\n	<li data-pk='<%= m.id %>'><a href='#food/<%= m.id %>'><%= m.get('name') %></a> <span class='delete'></span></li>\n<%})%>");

    Foods.prototype.events = {
      'click .delete': function(e) {
        return this.collection.get($(e.target).closest('li').attr('data-pk')).destroy();
      }
    };

    Foods.prototype.initialize = function() {
      var _this = this;
      return this.appendEvent(this.collection, 'all', function() {
        _this.$el.empty();
        return _this.render();
      });
    };

    return Foods;

  })(Backbone.View);

  App.ViewFood = Food = (function(_super) {

    __extends(Food, _super);

    function Food() {
      return Food.__super__.constructor.apply(this, arguments);
    }

    Food.prototype.template = _.template("<h1><%= this.model.get('name') || '' %></h1>\n<table class='table table-condensed'>\n	<thead>\n		<tr>\n			<th><%= _l('Title') %></th>\n			<th><%= _l('Weight') %></th>\n			<th><%= _l('Calories') %></th>\n			<th><%= _l('Protein') %></th>\n			<th><%= _l('Hydrates') %></th>\n			<th><%= _l('Fat') %></th>\n			<th><%= _l('Cholesterol') %></th>\n			<th></th>\n		</tr>\n	</thead>\n	<tbody>\n	</tbody>\n	<tfoot>\n		<tr>\n			<td></td>\n			<td class='product-total-weight'></td>\n			<td class='product-total-calories'></td>\n			<td class='product-total-protein'></td>\n			<td class='product-total-hydrates'></td>\n			<td class='product-total-fat'></td>\n			<td class='product-total-cholesterol'></td>\n			<td></td>\n		</tr>\n	</tfoot>\n</table>\n<div class=\"form-actions\">\n	<div class=\"input-append\">\n		<input type='text' value='<%= this.getNewName() %>' />\n		<button class=\"btn btn-primary\" type=\"submit\"><%= _l('Save changes') %></button>\n	</div>\n</div>");

    Food.prototype.events = {
      'keypress .form-actions input': function(e) {
        if (e.keyCode === 13) {
          return this.save();
        }
      },
      'click .form-actions button': 'save'
    };

    Food.prototype.initialize = function() {
      var _this = this;
      this.appendEvent(this.model.products, 'add', function(m) {
        return _this._addProduct(m);
      });
      this.appendEvent(this.model.products, 'remove', function(m) {
        return _this._removeProduct(m);
      });
      return this.appendEvent(this.model.products, 'all', function(m) {
        return _this.update();
      });
    };

    Food.prototype.save = function() {
      this.model.set({
        'name': this.$('.form-actions input').val()
      });
      return this.trigger('save');
    };

    Food.prototype.getNewName = function() {
      var c, match, n, name;
      name = this.model.get('name') || '';
      if (name === '') {
        return '';
      }
      match = /(.+) \(([0-9]+)\)/.exec(name);
      n = match ? match[1] : name;
      c = match ? parseInt(match[2]) : 0;
      return n + ' (' + (c + 1) + ')';
    };

    Food.prototype.update = function() {
      var p, _i, _len, _ref, _results;
      _ref = ['weight', 'calories', 'protein', 'hydrates', 'fat', 'cholesterol'];
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        p = _ref[_i];
        _results.push(this.$(".product-total-" + p).html(this.model[p]().toFixed()));
      }
      return _results;
    };

    Food.prototype._addProduct = function(m) {
      var pr;
      pr = new FoodProduct({
        model: m
      });
      this.appendSubView(pr);
      pr.render();
      m.prView = pr;
      return this.tbody.append(pr.$el);
    };

    Food.prototype._removeProduct = function(m) {
      return m.prView.remove();
    };

    Food.prototype.render = function() {
      var form_actions,
        _this = this;
      Food.__super__.render.apply(this, arguments);
      this.tbody = this.$('tbody');
      this.update();
      form_actions = this.$('.form-actions');
      form_actions.css('display', 'none');
      this.appendEvent(this.model, 'change', _.once(function() {
        return form_actions.css('display', '');
      }));
      return this.model.products.each(function(m) {
        return _this._addProduct(m);
      });
    };

    return Food;

  })(Backbone.View);

  FoodProduct = (function(_super) {

    __extends(FoodProduct, _super);

    function FoodProduct() {
      return FoodProduct.__super__.constructor.apply(this, arguments);
    }

    FoodProduct.prototype.tagName = 'tr';

    FoodProduct.prototype.template = _.template("<td><%= this.model.product.get('name') %></td>\n<td><input type='text' value='<%= this.model.get('weight') %>' /></td>\n<td class='product-calories'></td>\n<td class='product-protein'></td>\n<td class='product-hydrates'></td>\n<td class='product-fat'></td>\n<td class='product-cholesterol'></td>\n<td><span class='delete'></span></td>");

    FoodProduct.prototype.events = {
      'click .delete': function() {
        return this.model.destroy();
      },
      'keyup input': function() {
        var v;
        v = this.$('input').attr('value').replace(',', '.');
        if (new RegExp('^[0-9,.]+$').test(v)) {
          this.$('input').removeClass('error');
        } else {
          this.$('input').addClass('error');
        }
        return this.model.set({
          weight: parseFloat(v)
        });
      }
    };

    FoodProduct.prototype.initialize = function() {
      var _this = this;
      this.appendEvent(this.model, 'all', function() {
        return _this.update();
      });
      return this.appendEvent(this.model, 'destroy', function() {
        return _this.remove();
      });
    };

    FoodProduct.prototype.update = function() {
      var p, _i, _len, _ref, _results;
      _ref = ['calories', 'protein', 'hydrates', 'fat', 'cholesterol'];
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        p = _ref[_i];
        _results.push(this.$(".product-" + p).html(this.model[p]().toFixed()));
      }
      return _results;
    };

    FoodProduct.prototype.render = function() {
      FoodProduct.__super__.render.apply(this, arguments);
      return this.update();
    };

    return FoodProduct;

  })(Backbone.View);

}).call(this);
