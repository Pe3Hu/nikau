extends MarginContainer


@onready var enemies = $Enemies

var sketch = null
var battlefield = null


func set_attributes(input_: Dictionary) -> void:
	sketch = input_.sketch
	battlefield = sketch.battlefield
	
	spawn_enemies()
	#enemy_turn()


func spawn_enemies() -> void:
	var options = []
	var biomass = 62
	
	
	for _i in Global.num.battlefield.size.col:
		var grid = Vector2(_i, 0)
		var cell = battlefield.get_cell(grid)
		options.append(cell)
	
	var kinds = {}
	
	for kind in Global.dict.enemy.kind:
		kinds[kind] = Global.dict.enemy.kind[kind].spawn.rarity
	
	
	while biomass > 0:
		var input = {}
		input.swarm = self
		input.cell = options.pick_random()
		input.kind = Global.get_random_key(kinds)
		
		var enemy = Global.scene.enemy.instantiate()
		enemies.add_child(enemy)
		enemy.set_attributes(input)
		#options.erase(input.cell)
		biomass -= Global.dict.enemy.kind[input.kind].spawn.biomass
	
	#for enemy in enemies.get_children():
	#	enemy.marker.paint_cell()
	
	sort_based_on_initiative() 


func enemy_turn() -> void:
	for enemy in enemies.get_children():
		enemy.marker.find_reserve_cell()
	
	for enemy in enemies.get_children():
		enemy.marker.slide()
	
	
	for slotmachine in sketch.slotmachines.get_children():
		slotmachine.spin()


func sort_based_on_initiative() -> void:
	var initiatives = {}
	
	for enemy in enemies.get_children():
		enemies.remove_child(enemy)
		
		if !initiatives.has(enemy.initiative.get_value()):
			initiatives[enemy.initiative.get_value()] = []
		
		initiatives[enemy.initiative.get_value()].append(enemy)
	
	var keys = initiatives.keys()
	keys.sort_custom(func(a, b): return a > b)
	
	for initiative in keys:
		initiatives[initiative].sort_custom(func(a, b): return a.index.get_number() < b.index.get_number())
		
		for enemy in initiatives[initiative]:
			enemies.add_child(enemy)

