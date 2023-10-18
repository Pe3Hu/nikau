extends MarginContainer


@onready var bg = $BG
@onready var essence = $Essence

var coil = null
var selected = null


func set_attributes(input_: Dictionary) -> void:
	coil = input_.coil
	
	input_.proprietor = self
	essence.set_attributes(input_)
	
	var style = StyleBoxFlat.new()
	bg.set("theme_override_styles/panel", style)
	set_selected(false)


func set_selected(selected_: bool) -> void:
	selected = selected_
	var style = bg.get("theme_override_styles/panel")
	
	match selected:
		true:
			style.bg_color = Global.color.facet.selected
		false:
			style.bg_color = Global.color.facet.unselected


func qualifies(facet_: MarginContainer) -> bool:
	return true
