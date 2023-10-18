extends MarginContainer


@onready var skull = $HBox/Skull
@onready var index = $HBox/Index
@onready var healthIcon = $HBox/Health/Icon
@onready var healthValue = $HBox/Health/Value
@onready var speedIcon = $HBox/Speed/Icon
@onready var speedValue = $HBox/Speed/Value

var battlefield = null
var marker = null
var initiative = null


func set_attributes(input_: Dictionary) -> void:
	battlefield = input_.battlefield
	initiative = 0
	
	set_icons()
	init_marker(input_.cell)


func set_icons() -> void:
	var input = {}
	input.type = "skull"
	input.subtype = 350
	skull.set_attributes(input)
	
	input = {}
	input.type = "number"
	input.subtype = Global.num.index.enemy
	index.set_attributes(input)
	Global.num.index.enemy += 1
	
	input.type = "indicator"
	input.subtype = "health"
	healthIcon.set_attributes(input)
	
	input = {}
	input.type = "number"
	input.subtype = 100
	healthValue.set_attributes(input)
	
	input.type = "indicator"
	input.subtype = "speed"
	speedIcon.set_attributes(input)
	
	input = {}
	input.type = "number"
	input.subtype = 3
	speedValue.set_attributes(input)


func init_marker(cell_: MarginContainer) -> void:
	var input = {}
	input.enemy = self
	input.cell = cell_
	var marker = Global.scene.marker.instantiate()
	battlefield.markers.add_child(marker)
	marker.set_attributes(input)
