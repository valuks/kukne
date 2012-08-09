var _l = function(s){
	var tr;
	if (__locale[App.language][s]){
		tr = __locale[App.language][s];
	} else {
		tr = 'Not translated: '+s
	}
	return tr;
}