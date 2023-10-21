extends Node


var rng = RandomNumberGenerator.new()
var arr = {}
var num = {}
var vec = {}
var color = {}
var dict = {}
var flag = {}
var node = {}
var scene = {}


func _ready() -> void:
	init_arr()
	init_num()
	init_vec()
	init_color()
	init_dict()
	init_node()
	init_scene()


func init_arr() -> void:
	arr.edge = [1, 2, 3, 4, 5, 6]
	
	#arr.element = ["aqua", "wind", "fire", "earth", "ice", "storm", "lava", "plant"]
	arr.element = ["aqua", "ice", "wind", "storm", "fire", "lava", "earth", "plant"]


func init_num() -> void:
	num.index = {}
	num.index.enemy = 0
	num.index.cell = 0
	num.index.combo = 0
	
	
	num.battlefield = {}
	num.battlefield.size = {}
	num.battlefield.size.col = 7
	num.battlefield.size.row = 19


func init_dict() -> void:
	init_neighbor()
	init_element()
	init_pattern()
	init_coil()
	init_enemy()


func init_neighbor() -> void:
	dict.neighbor = {}
	dict.neighbor.linear3 = [
		Vector3( 0, 0, -1),
		Vector3( 1, 0,  0),
		Vector3( 0, 0,  1),
		Vector3(-1, 0,  0)
	]
	dict.neighbor.linear2 = [
		Vector2( 0,-1),
		Vector2( 1, 0),
		Vector2( 0, 1),
		Vector2(-1, 0)
	]
	dict.neighbor.diagonal = [
		Vector2( 1,-1),
		Vector2( 1, 1),
		Vector2(-1, 1),
		Vector2(-1,-1)
	]
	
	dict.neighbor.hybrid = []
	
	for _i in dict.neighbor.linear2.size():
		dict.neighbor.hybrid.append(dict.neighbor.diagonal[_i])
		dict.neighbor.hybrid.append(dict.neighbor.linear2[_i])
	
	dict.neighbor.zero = [
		Vector2( 0, 0),
		Vector2( 1, 0),
		Vector2( 1, 1),
		Vector2( 0, 1)
	]
	dict.neighbor.hex = [
		[
			Vector2( 1,-1), 
			Vector2( 1, 0), 
			Vector2( 0, 1), 
			Vector2(-1, 0), 
			Vector2(-1,-1),
			Vector2( 0,-1)
		],
		[
			Vector2( 1, 0),
			Vector2( 1, 1),
			Vector2( 0, 1),
			Vector2(-1, 1),
			Vector2(-1, 0),
			Vector2( 0,-1)
		]
	]


func init_element() -> void:
	dict.element = {}
	dict.element.opposition = {}
	
	for _i in arr.element.size():
		var element = arr.element[_i]
		var opposition = arr.element[(_i + arr.element.size() / 2) % arr.element.size()]
		dict.element.opposition[element] = opposition
	
	
	dict.element.child = {}
	dict.element.child["aqua"] = ["ice", "plant"]
	dict.element.child["wind"] = ["storm", "ice"]
	dict.element.child["fire"] = ["lava", "storm"]
	dict.element.child["earth"] = ["plant", "lava"]
	
	dict.element.parent = {}
	dict.element.parent["ice"] = ["aqua", "wind"]
	dict.element.parent["storm"] = ["wind", "fire"]
	dict.element.parent["lava"] = ["fire", "earth"]
	dict.element.parent["plant"] = ["earth", "aqua"]


func init_pattern() -> void:
	dict.pattern = {}
	dict.pattern.index = {}
	
	var path = "res://asset/json/nikau_pattern.json"
	var array = load_data(path)
	
	for pattern in array:
		var index = int(pattern.index)
		dict.pattern.index[index] = {}
		dict.pattern.index[index].coil = {}
		dict.pattern.index[index].synergy = {}
		dict.pattern.index[index].grids = []
		
		for key in pattern:
			if key != "index":
				var words = key.split(" ")
				
				if words.has("coil"):
					var coil = int(words[1])
					dict.pattern.index[index].coil[coil] = pattern[key]
					dict.pattern.index[index].grids.append(Vector2(coil, pattern[key]))
				
				if words.has("synergy"):
					dict.pattern.index[index].synergy[words[1]] = pattern[key]
	
	for index in dict.pattern.index:
		var pattern = dict.pattern.index[index]
		var grids = []
		var y = 0
		
		for coil in pattern.coil:
			var grid = Vector2(coil, pattern.coil[coil])
			grids.append(grid)
			
			if abs(grid.y - 2) > y:
				y = abs(grid.y - 2)
		
		pattern.path = [Vector2()]
		
		for _i in grids.size():
			if _i > 0:
				var direction = grids[_i] - grids[_i - 1]
				pattern.path.append(direction)
	
	init_combo()


func init_combo() -> void:
	dict.combo = {}
	dict.combo.index = {}
	
	for _i in dict.pattern.index:
		for _j in dict.pattern.index:
			var flag = overlap_pattern_check([_i, _j])
			
			if !flag:
				for _l in dict.pattern.index:
					flag = overlap_pattern_check([_i, _l])
					
					if !flag:
						flag = overlap_pattern_check([_j, _l])
						
						if !flag:
							dict.combo.index[num.index.combo] = [_i, _j, _l]
							num.index.combo += 1


func overlap_pattern_check(indexs_: Array) -> bool:
	var a = dict.pattern.index[indexs_[0]].grids
	var b = dict.pattern.index[indexs_[1]].grids
	a.resize(2)
	b.resize(2)
	
	for grid in a:
		if b.has(grid):
			return true
	
	return false


func init_coil() -> void:
	dict.coil = {}
	dict.coil.index = {}
	
	var path = "res://asset/json/nikau_coil.json"
	var array = load_data(path)
	
	for coil in array:
		var index = int(coil.index)
		dict.coil.index[index] = {}
		dict.coil.index[index].element = {}
		
		for key in coil:
			if key != "index":
				var words = key.split(" ")
				var element = words[0]
				var volume = int(words[1])
				
				if !dict.coil.index[index].element.has(element):
					dict.coil.index[index].element[element] = {}
				
				dict.coil.index[index].element[element][volume] = coil[key]


func init_enemy() -> void:
	dict.enemy = {}
	dict.enemy.kind = {}
	var path = "res://asset/json/nikau_enemy.json"
	var array = load_data(path)
	
	for enemy in array:
		dict.enemy.kind[enemy.kind] = {}
		
		for key in enemy:
			if key != "kind":
				var words = key.split(" ")
				
				if !dict.enemy.kind[enemy.kind].has(words[0]):
					dict.enemy.kind[enemy.kind][words[0]] = {}
				
				dict.enemy.kind[enemy.kind][words[0]][words[1]] = enemy[key]


func init_node() -> void:
	node.game = get_node("/root/Game")


func init_scene() -> void:
	scene.sketch = load("res://scene/0/sketch.tscn")
	
	scene.slotmachine = load("res://scene/1/slotmachine.tscn")
	scene.coil = load("res://scene/1/coil.tscn")
	scene.facet = load("res://scene/1/facet.tscn")
	scene.pattern = load("res://scene/1/pattern.tscn")
	
	scene.essence = load("res://scene/2/essence.tscn")
	scene.mana = load("res://scene/2/mana.tscn")
	
	scene.cell = load("res://scene/3/cell.tscn")
	scene.enemy = load("res://scene/3/enemy.tscn")
	scene.marker = load("res://scene/3/marker.tscn")
	
	scene.consequence = load("res://scene/4/consequence.tscn")
	scene.impact = load("res://scene/4/impact.tscn")
	


func init_vec():
	vec.size = {}
	
	vec.size.letter = Vector2(20, 20)
	vec.size.icon = Vector2(32, 32)
	vec.size.number = Vector2(16, 32)
	vec.size.facet = vec.size.icon + Vector2(vec.size.number.x, 0)
	
	vec.size.cell = Vector2(24, 24)
	vec.size.png = Vector2(32, 32)
	init_window_size()


func init_window_size():
	vec.size.window = {}
	vec.size.window.width = ProjectSettings.get_setting("display/window/size/viewport_width")
	vec.size.window.height = ProjectSettings.get_setting("display/window/size/viewport_height")
	vec.size.window.center = Vector2(vec.size.window.width/2, vec.size.window.height/2)


func init_color():
	var h = 360.0
	
	color.facet = {}
	color.facet.selected = Color.from_hsv(160 / h, 0.6, 0.7)
	color.facet.unselected = Color.from_hsv(0 / h, 0.4, 0.9)
	
	color.cell = {}
	color.cell.even = Color.from_hsv(0 / h, 0.0, 0.8)
	color.cell.odd = Color.from_hsv(0 / h, 0.0, 0.2)
	
	color.element = {}
	color.element.aqua = Color.from_hsv(245 / h, 0.55, 0.75)
	color.element.ice = Color.from_hsv(215 / h, 1.0, 0.86)
	color.element.wind = Color.from_hsv(170 / h, 1.0, 0.55)
	color.element.storm = Color.from_hsv(225 / h, 0.5, 0.5)
	color.element.fire = Color.from_hsv(0 / h, 1.0, 0.75)
	color.element.lava = Color.from_hsv(195 / h, 1.0, 1.0)
	color.element.earth = Color.from_hsv(35 / h, 1.0, 0.75)
	color.element.plant = Color.from_hsv(15 / h, 0.25, 0.5)
#	color.element.aqua = Color.from_hsv(245 / h, 0.55, 0.55)
#	color.element.ice = Color.from_hsv(215 / h, 1.0, 0.66)
#	color.element.wind = Color.from_hsv(170 / h, 1.0, 0.35)
#	color.element.storm = Color.from_hsv(225 / h, 0.5, 0.3)
#	color.element.fire = Color.from_hsv(0 / h, 1.0, 0.55)
#	color.element.lava = Color.from_hsv(195 / h, 1.0, 0.8)
#	color.element.earth = Color.from_hsv(35 / h, 1.0, 0.55)
#	color.element.plant = Color.from_hsv(15 / h, 0.25, 0.3)


func save(path_: String, data_: String):
	var path = path_ + ".json"
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(data_)


func load_data(path_: String):
	var file = FileAccess.open(path_, FileAccess.READ)
	var text = file.get_as_text()
	var json_object = JSON.new()
	var parse_err = json_object.parse(text)
	return json_object.get_data()


func get_random_key(dict_: Dictionary):
	if dict_.keys().size() == 0:
		print("!bug! empty array in get_random_key func")
		return null
	
	var total = 0
	
	for key in dict_.keys():
		total += dict_[key]
	
	rng.randomize()
	var index_r = rng.randf_range(0, 1)
	var index = 0
	
	for key in dict_.keys():
		var weight = float(dict_[key])
		index += weight/total
		
		if index > index_r:
			return key
	
	print("!bug! index_r error in get_random_key func")
	return null
