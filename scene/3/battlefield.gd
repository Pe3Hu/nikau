extends MarginContainer


@onready var bg = $BG
@onready var cells = $Cells
@onready var markers = $Markers

var sketch = null


func set_attributes(input_: Dictionary) -> void:
	sketch = input_.sketch
	
	init_cells()
	#enemy_turn()


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
	
	set_cell_neighbors() 


func set_cell_neighbors() -> void:
	for cell in cells.get_children():
		for direction in Global.dict.neighbor.hybrid:
			var neighbor = get_cell(cell.grid + direction)
			
			if neighbor != null:
				cell.neighbors[neighbor] = direction


func get_cell(grid_: Vector2) -> MarginContainer:
	if grid_.y >= 0 and grid_.x >= 0 and grid_.x < Global.num.battlefield.size.col and grid_.y < Global.num.battlefield.size.row:
		var index = grid_.y * Global.num.battlefield.size.col + grid_.x
		return cells.get_child(index)
	
	return null


func check_row_on_markers(row_: int) -> bool:
	for _i in Global.num.battlefield.size.col:
		var grid = Vector2(_i, row_)
		var cell = get_cell(grid)
		
		if cell.marker.current != null:
			return true
	
	return false


func check_anchor_bounds_based_on_pattern_index(anchor_: Vector2, index_: int) -> bool:
	var grid = Vector2(anchor_)
	
	for direction in Global.dict.pattern.index[index_].path:
		grid += direction
		var cell = get_cell(grid)
		
		if cell == null:
			return false
	
	return true


func check_anchor_for_markers_based_on_pattern_index(anchor_: Vector2, index_: int) -> bool:
	if check_anchor_bounds_based_on_pattern_index(anchor_, index_):
		var grid = Vector2(anchor_)
		
		for direction in Global.dict.pattern.index[index_].path:
			grid += direction
			var cell = get_cell(grid)
			
			if cell.marker.current != null:
				return true
	
	return false
