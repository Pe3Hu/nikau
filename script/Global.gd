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
	
	num.battlefield = {}
	num.battlefield.size = {}
	num.battlefield.size.col = 7
	num.battlefield.size.row = 19


func init_dict() -> void:
	init_neighbor()
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
		
		for key in pattern:
			if key != "index":
				var words = key.split(" ")
				
				if words.has("coil"):
					var coil = int(words[1])
					dict.pattern.index[index].coil[coil] = pattern[key]
				
				if words.has("synergy"):
					dict.pattern.index[index].synergy[words[1]] = pattern[key]


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
	
	
	pass


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
