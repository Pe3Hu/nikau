extends MarginContainer


@onready var bg = $BG
@onready var facets = $BG/Facets
@onready var timer = $Timer

var slotmachine = null
var tween = null
var index = null
var pace = null
var tick = null
var time = null
var skip = false#false true
var anchor = null
var selected = null


func set_attributes(input_: Dictionary) -> void:
	slotmachine = input_.slotmachine
	index = input_.index
	
	init_facets()
	update_size()
	
	shuffle_facets()
	facets.position.y = -Global.vec.size.facet.y * 1
	#skip_animation()


func init_facets() -> void:
	var description = Global.dict.coil.index[index]
	
	for element in description.element:
		for volume in description.element[element]:
			var input = {}
			input.coil = self
			input.element = element
			input.volume = volume
			var facet = Global.scene.facet.instantiate()
			facets.add_child(facet)
			facet.set_attributes(input)


func update_size() -> void:
	time = Time.get_unix_time_from_system()
	anchor = Vector2(0, -Global.vec.size.facet.y)
	var vector = Global.vec.size.facet
	vector.y *= 5
	custom_minimum_size = vector


func reset() -> void:
	pace = 400
	tick = 0


func spin() -> void:
	reset()
	timer.set_one_shot(false)
	timer.start()


func shuffle_facets() -> void:
	var facets_ = []
	
	for facet in facets.get_children():
		facets.remove_child(facet)
		facets_.append(facet)
	
	facets_.shuffle()
	
	for facet in facets_:
		facets.add_child(facet)


func decelerate_spin() -> void:
	tick += 1
	var limit = {}
	limit.min = 10.0
	limit.max = max(limit.min, 25.0 - tick * 1.0)
	Global.rng.randomize()
	var gap = Global.rng.randf_range(limit.min, limit.max)
	pace = max(pace - gap, 5.0)
	timer.wait_time = 1.0 / pace
	
	if pace == 5.0:
		timer.set_one_shot(true)


func _on_timer_timeout():
	var time_ = 1.0 / pace
	tween = create_tween()
	tween.tween_property(facets, "position", Vector2(0, 0), time_).from(anchor)
	tween.tween_callback(pop_up)


func pop_up() -> void:
	var facet = facets.get_child(facets.get_child_count() - 1)
	facets.move_child(facet, 0)
	
	if !skip:
		facets.position = anchor
		timer.start()
	
	if timer.is_one_shot():
		timer.stop()
		slotmachine.spins.erase(self)
		slotmachine.spin_end_check()
		#print([get_index(), "end at", Time.get_unix_time_from_system() - time])
	else:
		decelerate_spin()


func skip_animation() -> void:
	var facet = facets.get_children().pick_random()
	var index_ = facet.get_index()
	var step = 1 - index_
	
	if step < 0:
		step = facets.get_child_count() - index_ + 1
	
	for _j in step:
		pop_up()
	
	#scroll_to_value(facet.get_index())


func scroll_to_facet(facet_: MarginContainer) -> void:
	for facet in facets.get_children():
		if facet.match(facet_):
			var index_ = facet.get_index()
			var step = 1 - index_
			
			if step < 0:
				step = facets.get_child_count() - index_ + 1
			
			for _j in step:
				pop_up()
			
			return


func select_facet(spot_: int) -> void:
	if selected != null:
		selected.set_selected(false)
	
	selected = facets.get_child(spot_)
	selected.set_selected(true)


func crush() -> void:
	get_parent().remove_child(self)
	queue_free()
