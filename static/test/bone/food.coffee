module 'Food', 
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
		App.foods = new App.CollectionFoods([
			{'id': 'dd1207c4-563b-7804-e4f2-a7e6d76348c8', 'name': 'Tuoma zupene', 'products': [{'product': 1, 'weight': 20}, {'product': 2, 'weight': 30}]},
			{'id': 'dd1207c4-563b-7804-e4f2-aa341234aedf', 'name': 'Buļbys Tuoma gaumī', 'products': [{'product': 5, 'weight': 66}]},
		])

	teardown: ->
		App = this.App


test 'Collection', ->
	equal(App.foods.models[0].get('name'), 'Tuoma zupene')
	equal(App.foods.models[0].calories(), 24.5)
	equal(App.foods.models[0].protein(), 0)
	equal(App.foods.models[0].hydrates(), 6)
	equal(App.foods.models[0].fat(), 0)
	equal(App.foods.models[0].cholesterol(), 0)
	equal(App.foods.models[0].weight(), 50)

test 'Model', ->
	m = App.foods.models[0]
	equal(m.products.models[0].get('weight'), 20)
	equal(m.products.models[0].product.get('name'), 'Āboli')
	equal(m.products.models[0].calories(), 9.8)
	equal(m.products.models[0].protein(), 0)
	equal(m.products.models[0].hydrates(), 2.4)
	equal(m.products.models[0].fat(), 0)
	equal(m.products.models[0].cholesterol(), 0)
	# add product without weight
	m.addProduct({'product': 3})
	equal(m.products.models[2].get('weight'), 0)
	# add product
	m.addProduct({'product': 4, 'weight': 83})
	equal(m.products.models[3].get('weight'), 83)
	deepEqual(m.get('products'), [{'product': 1, 'weight': 20}, {'product': 2, 'weight': 30}, {'product': 3, 'weight': 0}, {'product': 4, 'weight': 83}])
	# remove product
	m.removeProduct(4)
	deepEqual(m.get('products'), [{'product': 1, 'weight': 20}, {'product': 2, 'weight': 30}, {'product': 3, 'weight': 0}])

test 'View', ->
	v = new App.ViewFoodsNavigation collection: App.foods
	v.render()
	v.$el.appendTo $('body')
	equal(v.$el.find('>li:eq(0)>a').html(), 'Tuoma zupene')
	equal(v.$el.find('>li:eq(0)>a').attr('href'), '#food/dd1207c4-563b-7804-e4f2-a7e6d76348c8')
	equal(v.$el.find('>li:eq(1)>a').html(), 'Buļbys Tuoma gaumī')
	equal(v.$el.find('>li:eq(1)>a').attr('href'), '#food/dd1207c4-563b-7804-e4f2-aa341234aedf')
	App.foods.add({'id': 'ew', 'name': 'new'})
	equal(v.$el.find('>li:eq(2)>a').html(), 'new')
	equal(v.$el.find('>li:eq(2)>a').attr('href'), '#food/ew')
	# remove
	v.$el.find('>li:eq(2)>span').click()
	equal(v.$el.find('>li').length, 2)

	v.remove()

test 'ViewFood', ->
	m = new App.foods.model
	v = new App.ViewFood model: m
	v.render()
	v.$el.appendTo $('body')
	equal(v.$el.find('h1').html(), '')
	equal(v.$el.find('table>thead>tr>th:eq(0)').html(), 'Pasaukšona')
	equal(v.$el.find('table>thead>tr>th:eq(1)').html(), 'Svors')
	equal(v.$el.find('table>thead>tr>th:eq(2)').html(), 'Kcal')
	equal(v.$el.find('table>thead>tr>th:eq(3)').html(), 'Boltonumi')
	equal(v.$el.find('table>thead>tr>th:eq(4)').html(), 'Ūgliudini')
	equal(v.$el.find('table>thead>tr>th:eq(5)').html(), 'Tuklumi')
	equal(v.$el.find('table>thead>tr>th:eq(6)').html(), 'Holesterins')
	# add products
	m.addProduct({'product': 2})
	equal(v.$el.find('table>tbody>tr').length, 1)
	equal(v.$el.find('table>tbody>tr>td:eq(0)').html(), 'Ananāss')
	equal(v.$el.find('table>tbody>tr>td:eq(1) input').attr('value'), '0')
	equal(v.$el.find('table>tbody>tr>td:eq(2)').html(), '0')
	equal(v.$el.find('table>tbody>tr>td:eq(3)').html(), '0')
	equal(v.$el.find('table>tbody>tr>td:eq(4)').html(), '0')
	equal(v.$el.find('table>tbody>tr>td:eq(5)').html(), '0')
	equal(v.$el.find('table>tbody>tr>td:eq(6)').html(), '0')
	# change weight
	v.$el.find('table>tbody>tr>td:eq(1) input').attr('value', 123).trigger('keyup')
	equal(v.$el.find('table>tbody>tr>td:eq(2)').html(), '60')
	equal(v.$el.find('table>tbody>tr>td:eq(3)').html(), '0')
	equal(v.$el.find('table>tbody>tr>td:eq(4)').html(), '15') #14.76
	equal(v.$el.find('table>tbody>tr>td:eq(5)').html(), '0')
	equal(v.$el.find('table>tbody>tr>td:eq(6)').html(), '0')
	# error check
	v.$el.find('table>tbody>tr>td:eq(1) input').attr('value', '123a').trigger('keyup')
	ok(v.$el.find('table>tbody>tr>td:eq(1) input').hasClass('error'))
	v.$el.find('table>tbody>tr>td:eq(1) input').attr('value', '123').trigger('keyup')
	ok(!v.$el.find('table>tbody>tr>td:eq(1) input').hasClass('error'))
	# remove product
	m.removeProduct(2)
	equal(v.$el.find('table>tbody>tr').length, 0)
	# remove with button
	m.addProduct({'product': 3})
	equal(v.$el.find('table>tbody>tr').length, 1)
	v.$el.find('table>tbody>tr>td:eq(7) span').click()
	equal(v.$el.find('table>tbody>tr').length, 0)
	# test total footer
	equal(v.$el.find('table>tfoot>tr>td:eq(1)').html(), '0')
	m.addProduct({'product': 6})
	m.addProduct({'product': 7})
	v.$el.find('table>tbody>tr:eq(0)>td:eq(1) input').attr('value', '200').trigger('keyup')
	v.$el.find('table>tbody>tr:eq(1)>td:eq(1) input').attr('value', '100').trigger('keyup')
	equal(v.$el.find('table>tfoot>tr>td:eq(1)').html(), '300')
	v.remove()

test 'ViewFood exist', ->
	m = App.foods.models[0].clone()
	v = new App.ViewFood model: m
	v.render()
	v.$el.appendTo $('body')
	equal(v.$el.find('h1').html(), 'Tuoma zupene')
	equal(v.$el.find('table>tbody>tr').length, 2)
	# save button
	ok(!v.$('.form-actions').is(':visible'))
	equal(v.getNewName(), 'Tuoma zupene (1)')
	m.set({'name': 'Tuoma zupene (1)'})
	equal(v.getNewName(), 'Tuoma zupene (2)')
	ok(v.$('.form-actions').is(':visible'))

	# lets save new food
	spy = sinon.spy()
	v.on('save', spy)
	v.$('.form-actions button').click()
	equal(spy.callCount, 1)
	v.remove()



