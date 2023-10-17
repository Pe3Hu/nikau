extends MarginContainer


@onready var bg = $BG
@onready var facets = $BG/Facets
@onready var timer = $Timer

var slotmachine = null
var tween = null
var index = 0
var pace = null
var tick = null
var time = null
var skip = false#false true
var anchor = null
var temp = true


func set_attributes(input_: Dictionary) -> void:
	slotmachine = input_.slotmachine
	time = Time.get_unix_time_from_system()
	
	for _i in input_.facets:
		var input = {}
		input.coil = self
		input.element =  Global.arr.element[_i]
		input.value = 1
		var facet = Global.scene.facet.instantiate()
		facets.add_child(facet)
		facet.set_attributes(input)
	
	anchor = Vector2(0, -Global.vec.size.facet.y)
	update_size()
	reset()
	#skip_animation()


func update_size() -> void:
	var vector = Global.vec.size.facet
	vector.y *= 3
	custom_minimum_size = vector


func reset() -> void:
	shuffle_facets()
	pace = 50
	tick = 0
	facets.position.y = -Global.vec.size.facet.y * 1
	timer.start()


func shuffle_facets() -> void:
	var temp = []
	
	for facet in facets.get_children():
		facets.remove_child(facet)
		temp.append(facet)
	
	temp.shuffle()
	
	for facet in temp:
		facets.add_child(facet)


func decelerate_spin() -> void:
	tick += 1
	var limit = {}
	limit.min = 1.0
	limit.max = max(limit.min, 5.0 - tick * 0.05)
	#start 50 min 0.5 max 2.5 step 0.1 stop 4 = 10 sec
	#start 50 min 1.5 max 2.5 step 0.1 stop 4 = 5 sec
	#start 100 min 2.0 max 3.0 step 0.1 stop 4 = 4 sec
	#start 50 min 1.0 max 5.0 step 0.1 stop 4 = 2.5 sec
	#start 50 min 2.0 max 3.0 step 0.1 stop 10 = 2.5 sec
	#start 50 min 2.0 max 5.0 step 0.1 stop 10 = 2 sec
	#start 100 min 1.0 max 10.0 step 0.1 stop 10 = 2.2 sec
	Global.rng.randomize()
	var gap = Global.rng.randf_range(limit.min, limit.max)
	pace = max(pace - gap, 0.5)
	timer.wait_time = 1.0 / pace
	
	if pace == 0.5:
		timer.set_paused(true)
		#var facet = facets.get_child(1)
		#print([get_index(), facet.tokenIcon.subtype, "end at", Time.get_unix_time_from_system() - time])
		
	#print([get_index(), pace])


func _on_timer_timeout():
	var time = 1.0 / pace
	tween = create_tween()
	tween.tween_property(facets, "position", Vector2(0, 0), time).from(anchor)
	tween.tween_callback(pop_up)
	decelerate_spin()


func pop_up() -> void:
	var facet = facets.get_child(facets.get_child_count() - 1)
	facets.move_child(facet, 0)
	
	if !skip:
		facets.position = anchor
		timer.start()


func skip_animation() -> void:
	var facet = facets.get_children().pick_random()
	var index = facet.get_index()
	var step = 1 - index
	
	if step < 0:
		step = facets.get_child_count() - index + 1
	
	for _j in step:
		pop_up()
	
	#scroll_to_value(facet.get_index())


func scroll_to_facet(facet_: MarginContainer) -> void:
	for facet in facets.get_children():
		if facet.match(facet_):
			var index = facet.get_index()
			var step = 1 - index
			
			if step < 0:
				step = facets.get_child_count() - index + 1
			
			for _j in step:
				pop_up()
			
			return


func get_current_facet_value() -> int:
	var facet =  facets.get_child(1)
	return facet.value


func crush() -> void:
	get_parent().remove_child(self)
	queue_free()
