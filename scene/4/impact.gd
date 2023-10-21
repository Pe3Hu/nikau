extends MarginContainer


@onready var enemyIcon = $HBox/Enemy/Icon
@onready var enemyIndex = $HBox/Enemy/Index
@onready var indicators = $HBox/Indicators
@onready var damage = $HBox/Indicators/Damage

var consequence = null
var enemy = null


func set_attributes(input_: Dictionary) -> void:
	consequence = input_.consequence
	enemy = input_.enemy
	
	set_icons()


func set_icons() -> void:
	var input = {}
	input.type = "skull"
	input.subtype = enemy.kind
	enemyIcon.set_attributes(input)
	
	input.type = "number"
	input.subtype = enemy.index.get_number()
	enemyIndex.set_attributes(input)
	
	input.proprietor = self
	input.type = "ui"
	input.title = "damage"
	input.value = consequence.damage[enemy]
	damage.set_attributes(input)
#
#	input.type = "ui"
#	input.subtype = "anchor"
#	patternIcon.set_attributes(input)
#
#	input.type = "number"
#	input.subtype = consequence.anchor.index
#	patternIndex.set_attributes(input)
