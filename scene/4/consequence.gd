extends MarginContainer


@onready var patternIcon = $HBox/VBox/Pattern/Icon
@onready var patternIndex = $HBox/VBox/Pattern/Index
@onready var anchorIcon = $HBox/VBox/Anchor/Icon
@onready var anchorIndex = $HBox/VBox/Anchor/Index
@onready var impacts = $HBox/Impacts

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
	
	set_icons()
	set_enemies()
	calc_damage()
	init_impacts()
	


func set_icons() -> void:
	var input = {}
	input.type = "ui"
	input.subtype = "pattern"
	patternIcon.set_attributes(input)
	
	input.type = "number"
	input.subtype = pattern.index.get_number()
	patternIndex.set_attributes(input)
	
	input.type = "ui"
	input.subtype = "anchor"
	anchorIcon.set_attributes(input)
	
	input.type = "number"
	input.subtype = anchor.index
	anchorIndex.set_attributes(input)


func set_enemies() -> void:
	var grid = Vector2(anchor.grid)
	
	for direction in Global.dict.pattern.index[pattern.index.get_number()].path:
		grid += direction
		var cell = battlefield.get_cell(grid)
	
		if cell.marker.current != null:
			enemies.append(cell.marker.current.enemy)


func calc_damage() -> void:
	rate.damage = 0
	var release = pattern.get_mana_release()
	
	for enemy in enemies:
		damage[enemy] = enemy.calc_expected_damage_based_on_mana_release(release)
		rate.damage += damage[enemy]


func init_impacts() -> void:
	for enemy in enemies:
		var input = {}
		input.consequence = self
		input.enemy = enemy
		var impact = Global.scene.impact.instantiate()
		impacts.add_child(impact)
		impact.set_attributes(input)
