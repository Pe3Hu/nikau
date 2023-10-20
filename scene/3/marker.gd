extends MarginContainer


@onready var skull = $Skull
@onready var index = $Index

var tween = null
var enemy = null
var battlefield = null
var cell = {}
var destinations = {}
var departures = []
var length = null
var action = true


func set_attributes(input_: Dictionary) -> void:
	enemy = input_.enemy
	battlefield = input_.enemy.swarm.battlefield
	cell.future = null
	occupy_cell(input_.cell)
	
	var input = {}
	input.type = "skull"
	input.subtype = enemy.kind
	skull.set_attributes(input)
	
	input = {}
	input.type = "number"
	input.subtype = enemy.index.get_number()
	index.set_attributes(input)
	
	var shift = Vector2(0.125, 0.125) * Global.vec.size.cell
	position = cell.current.grid * Global.vec.size.cell - shift
	scale = Global.vec.size.cell / Global.vec.size.icon


func occupy_cell(cell_: MarginContainer) -> void:
	if cell.future != null:
		cell.future.marker.future = null
		cell.future = null
	
	while cell_.marker.current != null:
		cell_ = cell_.get_closer_cell()
	
	cell_.marker.current = self
	cell.current = cell_
	var opposition = Global.dict.element.opposition[enemy.element]
	cell.current.set_color_based_on_element(opposition)


func reserve_cell(cell_: MarginContainer) -> void:
	cell.current.set_parity_color()
	cell.current.marker.current = null
	cell.current = null
	
	cell_.marker.future = self
	cell.future = cell_


func find_reserve_cell() -> void:
	var destination = null
	skull.visible = false
	
	if enemy.kind == "leaper":
		destination = leap()
	
	if destination == null:
		set_destinations_based_on_dijkstra()
		var datas = []
		var remoteness = cell.current.remoteness
		
		for cell_ in destinations:
			var data = {}
			data.cell = cell_
			data.remoteness = cell_.remoteness
			data.step = destinations[cell_].step
			data.length = destinations[cell_].length
			
			if remoteness > data.remoteness:
				remoteness = data.remoteness
			
			datas.append(data)
		
		var options = []
		
		if remoteness > 0:
			datas.sort_custom(func(a, b): return  a.remoteness - a.step < b.remoteness - b.step)
			
			for data in datas:
				if data.remoteness == datas.front().remoteness:
					options.append(data)
					
			destination = options.pick_random().cell
		else:
			datas.sort_custom(func(a, b): return  a.length < b.length)
			
			for data in datas:
				if data.remoteness == remoteness:
					options.append(data)
			
			destination = options.front().cell
	
	reserve_cell(destination)


func slide() -> void:
	if cell.future != null:
		var time = 0.5
		var destination = cell.future.grid * Global.vec.size.cell - Vector2.ONE * 0.125 * Global.vec.size.cell
		tween = create_tween()
		tween.tween_property(self, "position", destination, time).from(position)
		tween.tween_callback(slide_end)


func slide_end() -> void:
	if cell.future.remoteness != 0:
		occupy_cell(cell.future)
	else:
		cell.future.marker.future = null
		enemy.detonation()


func set_destinations_based_on_dijkstra() -> void:
	destinations = {}
	departures = []
	length = enemy.speed.get_value()
	
	add_destination(cell.current)
	compare_two_cells(cell.current, cell.current)
	
	if length > 0:
		while !departures.is_empty():
			departures.sort_custom(func(a, b): return  destinations[a].length <  destinations[b].length)
			var departure = departures.pop_front()
			
			if departure != null:
				for neighbor in departure.neighbors:
					if neighbor.marker.future == null and cell.current.remoteness >= neighbor.remoteness:
						add_destination(neighbor)
						compare_two_cells(departure, neighbor)
			
		for destination in destinations.keys():
			if destinations[destination].parent == null:
				destinations.erase(destination)


func add_destination(cell_: MarginContainer) -> void:
	if !destinations.has(cell_):
		destinations[cell_] = {}
		destinations[cell_].parent = null
		destinations[cell_].length = length + 1


func compare_two_cells(parent_: MarginContainer, child_: MarginContainer) -> void:
	if parent_ == cell.current and child_ == cell.current:
		destinations[child_].length = 0
		destinations[child_].parent = parent_
		destinations[child_].step = 0
		departures.append(child_)
	else:
		var l = {}
		l.old = destinations[child_].length
		l.new = destinations[parent_].length + parent_.get_length_on_neighbor(child_)
		
		if l.new < l.old and l.new <= length:
			destinations[child_].length = l.new
			destinations[child_].parent = parent_
			destinations[child_].step = destinations[parent_].step + 1
			departures.append(child_)


func paint_cell() -> void:
	var h = float(enemy.index.get_number()) / Global.num.index.enemy
	var style = cell.current.bg.get("theme_override_styles/panel")
	style.bg_color = Color.from_hsv(h, 1.0, 1.0)


func leap() -> Variant:
	var touchdown = null
	
	if action:
		for _i in range(cell.current.grid.y + 1, Global.num.battlefield.size.row - 1, 1):
			var grid = Vector2(cell.current.grid.x, _i)
			var cell_ = battlefield.get_cell(grid)
			#print([grid,  cell_.future])
			
			if cell_.marker.future != null:
				touchdown = battlefield.get_cell(grid + Vector2(0, 1))
		
		action = false
	return touchdown
