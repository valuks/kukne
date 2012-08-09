// Generated by CoffeeScript 1.3.3
(function() {
  var Products,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  App.ViewProductsNavigation = Products = (function(_super) {

    __extends(Products, _super);

    function Products() {
      return Products.__super__.constructor.apply(this, arguments);
    }

    Products.prototype.tagName = "ul";

    Products.prototype.className = 'nav-products';

    Products.prototype._active = [];

    Products.prototype.template = _.template("<% this.collection.each(function(m){ %>\n	<li><span><%= m.get('name') %></span><i class=\"badge\"></i>\n		<ul>\n			<% m.products.each(function(p){%>\n				<li data-pk='<%= p.id %>'><span><%= p.get('name') %></span></li>	\n			<%})%>\n		</ul>\n	</li>\n<%})%>");

    Products.prototype.events = {
      'click ul>li>span': function(e) {
        return $(e.currentTarget).closest('li').toggleClass('open');
      },
      'click ul>li>ul>li>span': 'toggleActive'
    };

    Products.prototype.active = function() {
      return this._active;
    };

    Products.prototype.updateCounter = function() {
      return this.$el.find('>li>ul').each(function() {
        var total;
        total = $(this).find('.active').length;
        return $(this).closest('li').find('>i').html(total > 0 ? total : '');
      });
    };

    Products.prototype.activate = function(id, silent) {
      var _this = this;
      if (silent == null) {
        silent = false;
      }
      if (_.isArray(id)) {
        return _.each(id, function(id) {
          return _this.activate(id, true);
        });
      }
      this._active.push(id);
      this.$el.find('li[data-pk="' + id + '"]').addClass('active');
      this.updateCounter();
      if (!silent) {
        return this.trigger('active', id);
      }
    };

    Products.prototype.deactivate = function(id, silent) {
      var _this = this;
      if (silent == null) {
        silent = false;
      }
      if (!id) {
        return _.each(_.clone(this._active), function(id) {
          return _this.deactivate(id, true);
        });
      }
      this._active.splice(_.indexOf(this._active, id), 1);
      this.$el.find('li[data-pk="' + id + '"]').removeClass('active');
      this.updateCounter();
      if (!silent) {
        return this.trigger('deactive', id);
      }
    };

    Products.prototype.toggleActive = function(e) {
      var id;
      id = parseInt($(e.currentTarget).closest('li').attr('data-pk'));
      if (__indexOf.call(this._active, id) >= 0) {
        return this.deactivate(id);
      } else {
        return this.activate(id);
      }
    };

    return Products;

  })(Backbone.View);

}).call(this);
