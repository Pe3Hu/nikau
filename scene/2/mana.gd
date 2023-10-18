extends MarginContainer


@onready var element = $HBox/Element
@onready var volume = $HBox/Volume


var proprietor = null


func set_attributes(input_: Dictionary) -> void:
	proprietor = input_.proprietor
	
	var input = {}
	input.type = "element"
	input.subtype = input_.element
	element.set_attributes(input)
	
	input = {}
	input.type = "number"
	input.subtype = input_.volume
	volume.set_attributes(input)


func change_volume(value_: int) -> void:
	volume.change_number(value_)
