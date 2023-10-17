extends MarginContainer


@onready var bg = $BG
@onready var tokenIcon = $Token/Icon
@onready var tokenValue = $Token/Value

var coil = null


func set_attributes(input_: Dictionary) -> void:
	coil = input_.coil
	
	var input = {}
	input.type = "element"
	input.subtype = input_.element
	tokenIcon.set_attributes(input)
	
	input = {}
	input.type = "number"
	input.subtype = input_.value
	tokenValue.set_attributes(input)
	
	var style = StyleBoxFlat.new()
	bg.set("theme_override_styles/panel", style)


func qualifies(facet_: MarginContainer) -> bool:
	return true
