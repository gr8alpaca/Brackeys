@tool
@icon("res://art/UI/ClassIcons16x16/text_line_numbers.png")
class_name Stats extends Resource

signal health_changed(health_delta: float)
signal guts_changed(guts_value: float)


@export_range(50.0, 200.0, 5.0, "or_greater", "or_less")
var base_life: float = 100.0

@export_range(50.0, 200.0, 5.0, "or_greater", "or_less")
var base_power: float = 100.0

@export_range(50.0, 200.0, 5.0, "or_greater", "or_less")
var base_speed: float = 100.0

@export_range(50.0, 200.0, 5.0, "or_greater", "or_less")
var base_skill: float = 100.0

@export_range(50.0, 200.0, 5.0, "or_greater", "or_less")
var base_defense: float = 100.0


var max_life: float = 100.0

var life: float = 100.0:
	set(val):
		if life == val: return
		var delta: float = val - life
		life = val
		health_changed.emit(delta)


var power: float = 100.0
var speed: float = 100.0
var skill: float = 100.0
var defense: float = 100.0

var guts: float = 50.0:
	set(val):
		var guts_delta: float = val - guts
		guts = val

@export_range(5.0, 18.0, 1.0, "suffix:guts/m") # guts_rate	4102	1	5,18,1,suffix:guts/m
var guts_rate: float = 13.0:
	set(val):
		guts_rate = val
		guts_per_minute = (30.0 / guts_rate) * 60.0 if guts_rate else 99999.9

@export_custom(0, "suffix:guts/min", PROPERTY_USAGE_EDITOR | PROPERTY_USAGE_READ_ONLY)
var guts_per_minute: int

func _validate_property(property: Dictionary) -> void:
	match property.name:
		&"max_life", &"life", &"power", &"speed", &"skill", &"defense", &"guts":
			property.usage |= 4 | PROPERTY_USAGE_READ_ONLY if Engine.is_editor_hint() else 4

