extends MarginContainer


@onready var bg = $BG

var battlefield = null
var grid = null


func set_attributes(input_: Dictionary) -> void:
	battlefield = input_.battlefield
	grid = input_.grid
	set_color()


func set_color() -> void:
	custom_minimum_size = Vector2(Global.vec.size.cell)
	var style = StyleBoxFlat.new()
	bg.set("theme_override_styles/panel", style)
	
	var parity = (int(grid.y) * Global.num.battlefield.size.col + int(grid.x)) % 2
	
	match parity:
		0:
			style.bg_color = Global.color.cell.even
		1:
			style.bg_color = Global.color.cell.odd
