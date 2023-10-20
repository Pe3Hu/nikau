extends MarginContainer



var sight = null
var pattern = null
var anchor = null
var battlefield = null
var enemies = []
var rate = {}
var damage = {}


func set_attributes(input_: Dictionary) -> void:
	sight = input_.sight
	pattern = input_.pattern
	anchor = input_.anchor
	battlefield = sight.battlefield
	
	set_enemies()
	call_damage()


func set_enemies() -> void:
	var grid = Vector2(anchor.grid)
	
	for direction in Global.dict.pattern.index[pattern.index.get_number()].path:
		grid += direction
		var cell = battlefield.get_cell(grid)
	
		if cell.marker.current != null:
			enemies.append(cell.marker.current.enemy)


func call_damage() -> void:
	rate.damage = 0
	var release = pattern.get_mana_release()
	
	for enemy in enemies:
		damage[enemy] = enemy.calc_expected_damage_based_on_mana_release(release)
		rate.damage += damage[enemy]
