extends MarginContainer


@onready var coils = $HBox/Coils
@onready var patterns = $HBox/Patterns

var spins = []
var sketch = null
var pattern = null


func set_attributes(input_: Dictionary) -> void:
	sketch = input_.sketch
	
	init_coils()
	init_patterns()


func init_coils() -> void:
	for _i in 5:
		var input = {}
		input.slotmachine = self
		input.index = _i
		var coil = Global.scene.coil.instantiate()
		coils.add_child(coil)
		coil.set_attributes(input)
		spins.append(coil)
	
	reset()


func init_patterns() -> void:
	for _i in Global.dict.pattern.index:
		var input = {}
		input.slotmachine = self
		input.index = _i
		var pattern = Global.scene.pattern.instantiate()
		patterns.add_child(pattern)
		pattern.set_attributes(input)
	
	pattern = patterns.get_child(12)


func reset() -> void:
	spins = []
	
	for coil in coils.get_children():
		spins.append(coil)


func change_pattern(shift_: int) -> void:
	pattern.visible = false
	var index = (pattern.get_index() + shift_ + Global.dict.pattern.index.keys().size()) % Global.dict.pattern.index.keys().size()
	pattern = patterns.get_child(index) 
	pattern.update_facets()


func spin_check() -> void:
	if spins.is_empty():
		for pattern_ in patterns.get_children():
			pattern_.fill_essences()
		
		change_pattern(0)


