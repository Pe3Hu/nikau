extends MarginContainer


@onready var enemies = $Enemies

var sketch = null
var battlefield = null


func set_attributes(input_: Dictionary) -> void:
	sketch = input_.sketch
	battlefield = sketch.battlefield
	
	spawn_enemies()


func spawn_enemies() -> void:
	var n = 7
	var options = []
	
	for _i in Global.num.battlefield.size.col:
		var grid = Vector2(_i, 0)
		var cell = battlefield.get_cell(grid)
		options.append(cell)
	
	var kinds = Global.dict.enemy.kind.keys()
	
	for _i in n:
		var input = {}
		input.swarm = self
		input.cell = options.pick_random()
		input.kind = kinds.pick_random()
		
		var enemy = Global.scene.enemy.instantiate()
		enemies.add_child(enemy)
		enemy.set_attributes(input)
		#options.erase(input.cell)


func enemy_turn() -> void:
	sort_based_on_initiative() 
	
	for enemy in enemies.get_children():
		enemy.marker.find_reserve_cell()
	
	for enemy in enemies.get_children():
		enemy.marker.slide()


func sort_based_on_initiative() -> void:
	var initiatives = {}
	
	for enemy in enemies.get_children():
		enemies.remove_child(enemy)
		
		if !initiatives.has(enemy.initiative.get_value()):
			initiatives[enemy.initiative.get_value()] = []
		
		initiatives[enemy.initiative.get_value()].append(enemy)
	
	var keys = initiatives.keys()
	keys.sort()
	
	for initiative in keys:
		initiatives[initiative].sort_custom(func(a, b): return a.index.get_number() < b.index.get_number())
		
		for enemy in initiatives[initiative]:
			enemies.add_child(enemy)
	
	
