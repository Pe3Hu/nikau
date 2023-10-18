extends MarginContainer


@onready var skull = $Skull
@onready var index = $Index

var enemy = null
var cell = {}


func set_attributes(input_: Dictionary) -> void:
	cell.current = null
	enemy = input_.enemy
	cell.next = input_.cell
	
	var input = {}
	input.type = "skull"
	input.subtype = 350
	skull.set_attributes(input)
	
	input = {}
	input.type = "number"
	input.subtype = enemy.index.get_number()
	index.set_attributes(input)
	
	position = cell.next.grid * Global.vec.size.cell - enemy.battlefield.size * 0.5
	print(position, enemy.battlefield.size)
