extends Node


func _ready() -> void:
	Global.node.sketch = Global.scene.sketch.instantiate()
	Global.node.game.get_node("Layer0").add_child(Global.node.sketch)
	#datas.sort_custom(func(a, b): return a.value < b.value)
	#012 description
	pass


func _input(event) -> void:
	if event is InputEventKey:
		match event.keycode:
			KEY_A:
				if event.is_pressed() && !event.is_echo():
					Global.node.sketch.slotmachines.get_child(0).change_pattern(-1)
			KEY_D:
				if event.is_pressed() && !event.is_echo():
					Global.node.sketch.slotmachines.get_child(0).change_pattern(1)
			KEY_1:
				if event.is_pressed() && !event.is_echo():
					Global.node.sketch.swarm.enemy_turn()
					
					


func _process(delta_) -> void:
	$FPS.text = str(Engine.get_frames_per_second())
