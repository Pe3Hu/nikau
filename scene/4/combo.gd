extends MarginContainer


var sight = null
var slotmachine = null
var consequences = []
var datas = {}


func set_attributes(input_: Dictionary) -> void:
	sight = input_.sight
	slotmachine = sight.slotmachine


func add_consequence(consequence_: MarginContainer) -> void:
	consequences.append(consequence_)
	consequence_.visible = true


func prepare_best_consequences_based_on_damage() -> void:
	datas.damage = []
	
	for consequence in sight.consequences.get_children():
		var data = {}
		data.consequence = consequence
		data.index = consequence.pattern.index.get_number()
		data.rate = consequence.rate.damage
		datas.damage.append(data)
	
	datas.damage.sort_custom(func(a, b): return a.rate > b.rate)


func find_best_consequence() -> void:
	var consequence = get_best_consequence_based_on_damage()
	#set_pattern_as_selected(consequence.pattern)
	#set_anchor_as_selected(consequence.anchor)
	consequence.visible = true
	#print([consequence.pattern.index.get_number(), consequence.anchor.grid, consequence.damage])


func get_best_consequence_based_on_damage() -> MarginContainer:
	var datas = []
	
	for consequence in consequences.get_children():
		var data = {}
		data.consequence = consequence
		data.rate = consequence.rate.damage
		datas.append(data)
	
	datas.sort_custom(func(a, b): return a.rate > b.rate)
	return datas.front().consequence


func find_best_trio_based_on_damage() -> void:
	var options = {}
	var index = null
	
	for option in Global.dict.combo.index:
		options[option] = {}
		options[option].consequences = []
		options[option].patterns = []
	
	for data in datas.damage:
		#if index != null:
		#	break
		
		for option in options:
			if false:
				pass
			#if index != null:
			#	break
			elif Global.dict.combo.index[option].has(data.index) and !options[option].patterns.has(data.consequence.pattern):
				options[option].consequences.append(data.consequence)
				options[option].patterns.append(data.consequence.pattern)
				
				if options[option].consequences.size() == 3:
					index = option
	
	for consequence in options[index].consequences:
		add_consequence(consequence)
