
# -*- coding: utf-8 -*-
import json

fr = 'source/produktiLG.txt'
to = 'static/js/data/products.lg.js'

# {'id': 1, 'name': 'Augļi un ogas', 'products': [
# 				{'id': 1, 'name': 'Āboli', 'calories': 49, 'protein': 0, 'hydrates': 12, 'fat': 0, 'cholesterol': 0},
# 				{'id': 2, 'name': 'Ananāss', 'calories': 49, 'protein': 0, 'hydrates': 12, 'fat': 0, 'cholesterol': 0},
# 				{'id': 3, 'name': 'Apelsīni', 'calories': 41, 'protein': 1, 'hydrates': 9, 'fat': 0, 'cholesterol': 0}
# 			]},

category = []
c_id = 1
pr_id = 1
def c(s):
	s = s.strip()
	if '.' in s:
		return float(s)
	if s == u'':
		return 0
	return int(s)
for l in open(fr).read().split("\n"):
	# print l
	data = l.strip().split("\t")
	# print data
	if len(data) == 1 and data[0] != '':
		# start new category
		category.append({'id': c_id, 'name': data[0], 'products': []})
		c_id += 1
	if len(data) > 1:
		category[-1]['products'].append({'id': pr_id, 'name': data[0], 'calories': c(data[1]), 'protein': c(data[3]), 'hydrates': c(data[4]), 'fat': c(data[5]), 'cholesterol': c(data[6])})
		pr_id += 1

open(to, 'w').write(u'var __products = {json};'.format(json = json.dumps(category)))
