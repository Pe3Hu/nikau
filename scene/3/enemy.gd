extends MarginContainer


@onready var skull = $HBox/VBox/Skull
@onready var index = $HBox/VBox/Index
@onready var indicators = $HBox/Indicators
@onready var initiative = $HBox/Indicators/Primary/Initiative
@onready var speed = $HBox/Indicators/Primary/Speed
@onready var health = $HBox/Indicators/Primary/Health
@onready var plague = $HBox/Indicators/Primary/Plague
@onready var recovery = $HBox/Indicators/Secondary/Recovery
@onready var mucus = $HBox/Indicators/Secondary/Mucus
@onready var chitin = $HBox/Indicators/Secondary/Chitin
@onready var dodge = $HBox/Indicators/Secondary/Dodge
@onready var aquaResistance = $HBox/Indicators/Resistance/Aqua
@onready var windResistance = $HBox/Indicators/Resistance/Wind
@onready var fireResistance = $HBox/Indicators/Resistance/Fire
@onready var earthResistance = $HBox/Indicators/Resistance/Earth

var swarm = null
var marker = null
var kind = null
var element = null


func set_attributes(input_: Dictionary) -> void:
	swarm = input_.swarm
	kind = input_.kind
	
	set_icons()
	roll_element()
	init_marker(input_.cell)


func set_icons() -> void:
	var description = Global.dict.enemy.kind[kind]
	var input = {}
	input.type = "skull"
	input.subtype = kind
	skull.set_attributes(input)
	
	input = {}
	input.type = "number"
	input.subtype = Global.num.index.enemy
	index.set_attributes(input)
	Global.num.index.enemy += 1
	
	var hboxs = ["Primary", "Secondary", "Resistance"]
	
	for hbox in hboxs:
		var node = indicators.get_node(hbox)
		
		for indicator in node.get_children():
			input = {}
			input.proprietor = self
			input.title = indicator.name.to_lower()
			input.value = description[hbox.to_lower()][input.title]
			indicator.set_attributes(input)


func init_marker(cell_: MarginContainer) -> void:
	var input = {}
	input.enemy = self
	input.cell = cell_
	marker = Global.scene.marker.instantiate()
	swarm.battlefield.markers.add_child(marker)
	marker.set_attributes(input)


func roll_element() -> void:
	var elements = ["aqua", "wind", "fire", "earth"]
	element = elements.pick_random()
	var opposition = Global.dict.element.opposition[element]
	var indicator = get(element + "Resistance")
	indicator.change_value(25)
	
	indicator = get(opposition + "Resistance")
	indicator.change_value(-50)


func detonation() -> void:
	swarm.battlefield.markers.remove_child(marker)
	marker.queue_free()
	swarm.enemies.remove_child(self)
	queue_free()


func calc_expected_damage_based_on_mana_release(release_: Dictionary) -> int:
	var value = 75
	
	if release_.element != "blood":
		if Global.dict.element.parent.has(release_.element):
			for child in Global.dict.element.parent[release_.element]:
				var indicator = get(child + "Resistance")
				value = max(value, indicator.get_value())
		else:
			var indicator = get(release_.element + "Resistance")
			value = indicator.get_value()
	
	var multiplier = 100.0 / (100 + value)
	
	if value < 0:
		multiplier = 2 - 100.0 / (100 - value)
	
	var result = floor(release_.volume * multiplier)
	return result
