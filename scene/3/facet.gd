extends MarginContainer


@onready var bg = $BG
@onready var tokenIcon = $Token/Icon
@onready var tokenValue = $Token/Value

var coil = null


func init(value_: int) -> void:
	pass


func _ready() -> void:
	var style = StyleBoxFlat.new()
	bg.set("theme_override_styles/panel", style)


