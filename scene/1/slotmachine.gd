extends MarginContainer


@onready var coils = $VBox/HBox/Coils
@onready var patterns = $VBox/HBox/Patterns
@onready var sight = $VBox/Sight

var spins = []
var sketch = null


func set_attributes(input_: Dictionary) -> void:
	sketch = input_.sketch
	
	var input = {}
	input.slotmachine = self
	sight.set_attributes(input)
	
	init_coils()
	init_patterns()
	spin()


func init_coils() -> void:
	for _i in 5:
		var input = {}
		input.slotmachine = self
		input.index = _i
		var coil = Global.scene.coil.instantiate()
		coils.add_child(coil)
		coil.set_attributes(input)
		spins.append(coil)


func init_patterns() -> void:
	for _i in Global.dict.pattern.index:
		var input = {}
		input.slotmachine = self
		input.index = _i
		var pattern = Global.scene.pattern.instantiate()
		patterns.add_child(pattern)
		pattern.set_attributes(input)
	
	sight.pattern = patterns.get_child(12)


func reset() -> void:
	spins = []
	
	for coil in coils.get_children():
		spins.append(coil)


func spin() -> void:
	reset()
	
	for coil in coils.get_children():
		if coil.selected != null:
			coil.selected.set_selected(false)
		
		coil.spin()


func spin_end_check() -> void:
	if spins.is_empty():
		for pattern in patterns.get_children():
			pattern.fill_essences()
			pattern.find_anchors()
		
		sight.set_consequences()
		sight.fill_combo_based_on_damage()
		#change_selected_pattern(0)
