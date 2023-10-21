extends MarginContainer


@onready var bg = $BG

var battlefield = null
var grid = null
var remoteness = null
var index = null
var neighbors = {}
var spawner = []
var marker = {}


func set_attributes(input_: Dictionary) -> void:
	battlefield = input_.battlefield
	grid = input_.grid
	remoteness = Global.num.battlefield.size.row - grid.y - 1
	index = Global.num.index.cell
	Global.num.index.cell += 1
	marker.current = null
	marker.future = null
	
	
	custom_minimum_size = Vector2(Global.vec.size.cell)
	var style = StyleBoxFlat.new()
	bg.set("theme_override_styles/panel", style)
	set_parity_color()


func set_parity_color() -> void:
	var style = bg.get("theme_override_styles/panel")
	var parity = (int(grid.y) * Global.num.battlefield.size.col + int(grid.x)) % 2
	
	match parity:
		0:
			style.bg_color = Global.color.cell.even
		1:
			style.bg_color = Global.color.cell.odd


func paint_color(color_: String) -> void:
	var style = bg.get("theme_override_styles/panel")
	style.bg_color = Color(color_)


func get_length_on_neighbor(neighbor_: MarginContainer) -> Variant:
	if neighbors.has(neighbor_):
		var direction = neighbors[neighbor_]
		
		if Global.dict.neighbor.diagonal.has(direction):
			return 1.5
		
		if Global.dict.neighbor.linear2.has(direction):
			return 1.0
	
	return null


func get_closer_cell() -> Variant:
	for neighbor in neighbors:
		var direction = neighbors[neighbor]
		
		if direction == Vector2(0, 1):
			return neighbor
	
	return null


func set_color_based_on_element(element_: String) -> void:
	var style = bg.get("theme_override_styles/panel")
	style.bg_color = Global.color.element[element_]
