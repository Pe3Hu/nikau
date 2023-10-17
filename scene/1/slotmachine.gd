extends MarginContainer


@onready var coils = $Coils

var sketch = null


func set_attributes(input_: Dictionary) -> void:
	sketch = input_.sketch
	
	init_coils()


func init_coils() -> void:
	for _i in 5:
		var input = {}
		input.slotmachine = self
		input.facets = Global.arr.element.size()
		var coil = Global.scene.coil.instantiate()
		coils.add_child(coil)
		coil.set_attributes(input)
