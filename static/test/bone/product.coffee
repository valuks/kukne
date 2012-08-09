module 'Product', 
	setup: ->
		this.App = App
		App.products = new App.CollectionProducts([
			{'id': 1, 'name': 'Augļi un ogas', 'products': [
				{'id': 1, 'name': 'Āboli', 'calories': 49, 'protein': 0, 'hydrates': 12, 'fat': 0, 'cholesterol': 0},
				{'id': 2, 'name': 'Ananāss', 'calories': 49, 'protein': 0, 'hydrates': 12, 'fat': 0, 'cholesterol': 0},
				{'id': 3, 'name': 'Apelsīni', 'calories': 41, 'protein': 1, 'hydrates': 9, 'fat': 0, 'cholesterol': 0}
			]},
			{'id': 2, 'name': 'Dārzeņi', 'products': [
				{'id': 4, 'name': 'Avokado', 'calories': 160, 'protein': 2, 'hydrates': 9, 'fat': 15, 'cholesterol': 0},
				{'id': 5, 'name': 'Bietes', 'calories': 43, 'protein': 2, 'hydrates': 10, 'fat': 0, 'cholesterol': 0}
			]},
			{'id': 3, 'name': 'Gaļa un gaļas produkti', 'products': [
				{'id': 6, 'name': 'Aknu desa', 'calories': 326, 'protein': 14, 'hydrates': 2, 'fat': 28, 'cholesterol': 158},
				{'id': 7, 'name': 'Cīsiņi', 'calories': 360, 'protein': 8, 'hydrates': 0, 'fat': 34, 'cholesterol': 70}
			]}
		])

	teardown: ->
		App = this.App


test 'Collection', ->
	equal(App.products.get(1).get('name'), 'Augļi un ogas')
	equal(App.products.get(2).get('name'), 'Dārzeņi')
	equal(App.products.byId(4).get('name'), 'Avokado')

test 'Model', ->
	equal(App.products.get(1).products.get(1).get('name'), 'Āboli')
	equal(App.products.get(1).products.get(1).get('category'), 1)
	equal(App.products.get(1).products.get(1).category.get('name'), 'Augļi un ogas')

test 'View', ->
	v = new App.ViewProductsNavigation collection: App.products
	active = sinon.spy()
	deactive = sinon.spy()
	v.render()
	v.$el.appendTo $('body')
	equal(v.$el.find('>li:eq(0) span').html(), 'Augļi un ogas')
	equal(v.$el.find('>li:eq(1) span').html(), 'Dārzeņi')
	equal(v.$el.find('>li:eq(0) li:eq(0) span').html(), 'Āboli')
	equal(v.$el.find('>li:eq(0) li:eq(1) span').html(), 'Ananāss')

	deepEqual(v.active(), [])
	v.on('active', active)
	v.on('deactive', deactive)
	ok(!v.$el.find('li:eq(0)>ul').is(':visible'))
	v.$el.find('li:eq(0)>span').click()
	ok(v.$el.find('li:eq(0)>ul').is(':visible'))
	# activate product
	v.$el.find('li:eq(0)>ul>li:eq(0)>span').click()
	equal(active.callCount, 1)
	ok(v.$el.find('li:eq(0)>ul>li:eq(0)').hasClass('active'))
	equal(v.$el.find('li:eq(0)>i').html(), 1)
	# activate 2. product
	v.$el.find('li:eq(0)>ul>li:eq(1)>span').click()
	equal(active.callCount, 2)
	ok(v.$el.find('li:eq(0)>ul>li:eq(1)').hasClass('active'))
	equal(v.$el.find('li:eq(0)>i').html(), 2)
	deepEqual(v.active(), [1, 2])
	# deactivate 2. product
	v.$el.find('li:eq(0)>ul>li:eq(1)>span').click()
	equal(active.callCount, 2)
	equal(deactive.callCount, 1)
	ok(!v.$el.find('li:eq(0)>ul>li:eq(1)').hasClass('active'))
	equal(v.$el.find('li:eq(0)>i').html(), 1)
	deepEqual(v.active(), [1])
	# deactivate 1. (last) product
	v.$el.find('li:eq(0)>ul>li:eq(0)>span').click()
	equal(v.$el.find('li:eq(0)>i').html(), '')
	deepEqual(v.active(), [])
	# activate by array
	aractive = sinon.spy()
	v.on('active', aractive)
	v.activate([1, 2, 3])
	ok(v.$el.find('li:eq(0)>ul>li:eq(0)').hasClass('active'))
	ok(v.$el.find('li:eq(0)>ul>li:eq(1)').hasClass('active'))
	ok(v.$el.find('li:eq(0)>ul>li:eq(2)').hasClass('active'))
	deepEqual(v.active(), [1, 2, 3])
	equal(aractive.callCount, 0)
	# deactivate all
	ardeactive = sinon.spy()
	v.on('deactive', ardeactive)
	v.deactivate()
	ok(!v.$el.find('li:eq(0)>ul>li:eq(0)').hasClass('active'))
	ok(!v.$el.find('li:eq(0)>ul>li:eq(1)').hasClass('active'))
	ok(!v.$el.find('li:eq(0)>ul>li:eq(2)').hasClass('active'))
	deepEqual(v.active(), [])
	equal(ardeactive.callCount, 0)
	v.remove()
