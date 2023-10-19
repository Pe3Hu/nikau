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


func set_attributes(input_: Dictionary) -> void:
	swarm = input_.swarm
	kind = input_.kind
	
	set_icons()
	init_marker(input_.cell)


func set_icons() -> void:
	var description = Global.dict.enemy.kind[kind]
	var input = {}
	input.type = "skull"
	input.subtype = 350
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

#	input.type = "indicator"
#	input.subtype = "health"
#	healthIcon.set_attributes(input)
#
#	input = {}
#	input.type = "number"
#	input.subtype = 100
#	healthValue.set_attributes(input)
#
#	input.type = "indicator"
#	input.subtype = "speed"
#	speedIcon.set_attributes(input)
#
#	input = {}
#	input.type = "number"
#	input.subtype = 3
#	speedValue.set_attributes(input)


func init_marker(cell_: MarginContainer) -> void:
	var input = {}
	input.enemy = self
	input.cell = cell_
	marker = Global.scene.marker.instantiate()
	swarm.battlefield.markers.add_child(marker)
	marker.set_attributes(input)
