extends MarginContainer

@onready var hbox = $HBox
@onready var cells = $HBox/Cells
@onready var enemies = $HBox/Enemies
@onready var markers = $Markers

var sketch = null


func set_attributes(input_: Dictionary) -> void:
	sketch = input_.sketch
	
	init_cells()
	spawn_enemies()


func init_cells() -> void:
	cells.columns = Global.num.battlefield.size.col
	
	for _i in Global.num.battlefield.size.row:
		for _j in Global.num.battlefield.size.col:
			var input = {}
			input.battlefield = self
			input.grid = Vector2(_j, _i)
			var cell = Global.scene.cell.instantiate()
			cells.add_child(cell)
			cell.set_attributes(input)
	


func spawn_enemies() -> void:
	var n = 3
	var options = []
	
	for _i in Global.num.battlefield.size.col:
		var grid = Vector2(_i, 0)
		var cell = get_cell(grid)
		options.append(cell)
	
	for _i in n:
		var input = {}
		input.battlefield = self
		input.cell = options.pick_random()
		
		var enemy = Global.scene.enemy.instantiate()
		enemies.add_child(enemy)
		enemy.set_attributes(input)
		options.erase(input.cell)


func get_cell(grid_: Vector2) -> MarginContainer:
	var index = grid_.y * Global.num.battlefield.size.col + grid_.x
	return cells.get_child(index)
