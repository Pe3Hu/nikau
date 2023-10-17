extends MarginContainer


@onready var slotmachines = $Slotmachines


func _ready() -> void:
	
	for _i in 1:
		var input = {}
		input.sketch = self
		var slotmachine = Global.scene.slotmachine.instantiate()
		slotmachines.add_child(slotmachine)
		slotmachine.set_attributes(input)
		
