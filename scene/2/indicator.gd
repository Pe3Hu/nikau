extends MarginContainer


@onready var title = $VBox/Title
@onready var value = $VBox/Value


var proprietor = null


func set_attributes(input_: Dictionary) -> void:
	proprietor = input_.proprietor
	
	var input = {}
	input.type = "indicator"
	input.subtype = input_.title
	title.set_attributes(input)
	
	input = {}
	input.type = "number"
	input.subtype = input_.value
	value.set_attributes(input)
	
	if input_.value == 0 and input_.title != "initiative":
		visible = false


func change_value(value_: int) -> void:
	value.change_number(value_)
	
	if get_value() != 0:
		visible = true


func get_value() -> int:
	return value.get_number()


