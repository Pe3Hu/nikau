extends MarginContainer


@onready var battlefield = $HBox/Battlefield
@onready var slotmachines = $HBox/Slotmachines


func _ready() -> void:
	var input = {}
	input.sketch = self
	battlefield.set_attributes(input)
	
	init_slotmachines()


func init_slotmachines() -> void:
	for _i in 1:
		var input = {}
		input.sketch = self
		var slotmachine = Global.scene.slotmachine.instantiate()
		slotmachines.add_child(slotmachine)
		slotmachine.set_attributes(input)
