extends MarginContainer


@onready var icon = $HBox/VBox/Icon
@onready var index = $HBox/VBox/Index
@onready var essences = $HBox/Essences
@onready var mana = $HBox/Mana

var slotmachine = null
var synergy = {}


func set_attributes(input_: Dictionary) -> void:
	slotmachine = input_.slotmachine
	
	synergy.element = null
	
	if Global.dict.pattern.index[input_.index].synergy.has("element"):
		synergy.element = Global.dict.pattern.index[input_.index].synergy.element
	
	synergy.volume = Global.dict.pattern.index[input_.index].synergy.volume
	
	var input = {}
	input.type = "ui"
	input.subtype = "pattern"
	icon.set_attributes(input)
	
	input = {}
	input.type = "number"
	input.subtype = input_.index
	index.set_attributes(input)
	
	init_essences()


func init_essences() -> void:
	for element in Global.arr.element:
		var input = {}
		input.proprietor = self
		input.element = element
		input.volume = 0
		var essence = Global.scene.essence.instantiate()
		essences.add_child(essence)
		essence.set_attributes(input)
		essence.visible = false


func fill_essences() -> void:
	var description = Global.dict.pattern.index[index.get_number()]
	
	for _i in description.coil:
		var slot = description.coil[_i]
		var coil = slotmachine.coils.get_child(_i)
		var facet = coil.facets.get_child(slot)
		var subtype = facet.essence.element.subtype
		var value = facet.essence.volume.get_number()
		change_essence(subtype, value)
	
	set_mana()


func set_mana() -> void:
	var datas = []
	
	for essence in essences.get_children():
		var data = {}
		data.element = essence.element.subtype
		data.volume = essence.volume.get_number()
		datas.append(data)
	
	datas.sort_custom(func(a, b): return a.volume > b.volume)
	
	var input = {}
	input.proprietor = self
	input.element = "blood"
	input.volume = datas.front().volume
	
	if datas.size() > 1:
		if datas[0].volume == datas[1].volume:
			input.volume = 0
			
			for _i in datas.size():
				if datas[_i].volume == datas.front().volume:
					input.volume += datas[_i].volume
				else:
					break
		else:
			input.element = datas.front().element
	
	if input.element == synergy.element:
		input.volume += synergy.volume
	
	mana.set_attributes(input)

func update_facets() -> void:
	visible = true
	var description = Global.dict.pattern.index[index.get_number()]
	
	for _i in description.coil:
		var slot = description.coil[_i]
		var coil = slotmachine.coils.get_child(_i)
		coil.select_facet(slot)


func get_essence(subtype_: String) -> Variant:
	for essence in essences.get_children():
		if essence.element.subtype == subtype_:
			return essence
	#var a = essences.get_children()
	return null


func change_essence(subtype_: String, value_: int) -> void:
	var essence = get_essence(subtype_)
	essence.volume.change_number(value_)
	essence.visible = essence.volume.get_number() > 0
