extends MarginContainer


@onready var consequences = $Consequences
@onready var combo = $Combo

var slotmachine = null
var battlefield = null
var pattern = null
var anchor = null


func set_attributes(input_: Dictionary) -> void:
	slotmachine = input_.slotmachine
	battlefield = slotmachine.sketch.battlefield
	
	var input = {}
	input.sight = self
	combo.set_attributes(input)
	


func change_selected_pattern(shift_: int) -> void:
	pattern.visible = false
	#print("___")
	#print(pattern.anchors.size())
	#for cell in pattern.anchors:
		#if cell.marker.current != null:
		#	cell.marker.current.skull.visible = false
		#cell.set_parity_color()
	
	if anchor == null:
		anchor = pattern.anchors[0]
	
	update_visible_marker_skull(false)
	var index = (pattern.get_index() + shift_ + Global.dict.pattern.index.keys().size()) % Global.dict.pattern.index.keys().size()
	pattern = slotmachine.patterns.get_child(index) 
	pattern.update_facets()
	
	#print(pattern.anchors.size())
	#for cell in pattern.anchors:
	#	cell.paint_color("yellow")
	
	anchor = null
	change_selected_anchor(0)


func update_visible_marker_skull(flag_: bool) -> void:
	var grid = Vector2(anchor.grid)
	
	for direction in Global.dict.pattern.index[pattern.index.get_number()].path:
		grid += direction
		var cell = battlefield.get_cell(grid)
		
		if cell.marker.current != null:
			cell.marker.current.skull.visible = flag_


func set_pattern_as_selected(pattern_: MarginContainer) -> void:
	var shift = (pattern_.get_index() - pattern.get_index() + slotmachine.patterns.get_child_count()) % slotmachine.patterns.get_child_count()
	change_selected_pattern(shift)


func change_selected_anchor(shift_: int) -> void:
	if anchor == null:
		anchor = pattern.anchors[0]
	
	update_visible_marker_skull(false)
	#if anchor.marker.current != null:
	#	anchor.marker.current.skull.visible = false
	#anchor.paint_color("yellow")
	
	var index = (pattern.anchors.find(anchor) + shift_ + pattern.anchors.size()) % pattern.anchors.size()
	anchor = pattern.anchors[index]
	update_visible_marker_skull(true)
		#cell.paint_color("red")


func set_anchor_as_selected(anchor_: MarginContainer) -> void:
	var shift = (pattern.anchors.find(anchor_) - pattern.anchors.find(anchor) + pattern.anchors.size()) % pattern.anchors.size()
	change_selected_anchor(shift)


func set_consequences() -> void:
	reset_consequence()
	
	for pattern_ in slotmachine.patterns.get_children():
		for anchor_ in pattern_.anchors:
			var input = {}
			input.sight = self
			input.pattern = pattern_
			input.anchor = anchor_
			var consequence = Global.scene.consequence.instantiate()
			consequences.add_child(consequence)
			consequence.set_attributes(input)


func reset_consequence() -> void:
	while consequences.get_child_count() > 0:
		var consequence = consequences.get_child(0)
		consequences.remove_child(consequence)
		consequence.queue_free()


func fill_combo_based_on_damage() -> void:
	combo.prepare_best_consequences_based_on_damage()
	combo.find_best_trio_based_on_damage()


func find_best_pattern_based_on_mana() -> void:
	var datas = []
	
	for pattern_ in slotmachine.patterns.get_children():
		var data = {}
		data.pattern = pattern_
		data.mana = pattern_.mana.get_volume()
		datas.append(data)
	
	datas.sort_custom(func(a, b): return a.mana > b.mana)
	#set_pattern_as_selected(datas.front().pattern)
