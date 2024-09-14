@tool
@icon("res://art/UI/ClassIcons16x16/text_line_numbers.png")
class_name Stats extends Resource

const MIN_STAT_VALUE: float = 1.0
const MAX_STAT_VALUE: float = 999.999
signal health_changed(health_delta: float)
signal guts_changed(guts_value: float)
signal dead


#region Stats

@export_range(50.0, 200.0, 5.0, "or_greater", "or_less")
var base_life: float = 100.0:
	set(val):
		base_life = clampf(val, MIN_STAT_VALUE, MAX_STAT_VALUE)
		changed.emit()

@export_range(50.0, 200.0, 5.0, "or_greater", "or_less")
var base_power: float = 100.0:
	set(val):
		base_power = clampf(val, MIN_STAT_VALUE, MAX_STAT_VALUE)
		changed.emit()

@export_range(50.0, 200.0, 5.0, "or_greater", "or_less")
var base_speed: float = 100.0:
	set(val):
		base_speed = clampf(val, MIN_STAT_VALUE, MAX_STAT_VALUE)
		changed.emit()

@export_range(50.0, 200.0, 5.0, "or_greater", "or_less")
var base_skill: float = 100.0:
	set(val):
		base_skill = clampf(val, MIN_STAT_VALUE, MAX_STAT_VALUE)
		changed.emit()

@export_range(50.0, 200.0, 5.0, "or_greater", "or_less")
var base_defense: float = 100.0:
	set(val):
		base_defense = clampf(val, MIN_STAT_VALUE, MAX_STAT_VALUE)
		changed.emit()

## THIS REPRESENTS MAX LIFE!!!!
var life: float = 100.0:
	set(val):
		life = clampf(val, MIN_STAT_VALUE, MAX_STAT_VALUE)
		changed.emit()

var power: float = 100.0:
	set(val):
		power = clampf(val, MIN_STAT_VALUE, MAX_STAT_VALUE)
		changed.emit()
var speed: float = 100.0:
	set(val):
		speed = clampf(val, MIN_STAT_VALUE, MAX_STAT_VALUE)
		changed.emit()
var skill: float = 100.0:
	set(val):
		skill = clampf(val, MIN_STAT_VALUE, MAX_STAT_VALUE)
		changed.emit()
var defense: float = 100.0:
	set(val):
		defense = clampf(val, MIN_STAT_VALUE, MAX_STAT_VALUE)
		changed.emit()


#endregion Stats


## What life is currently at.
var current_life: float = 100.0:
	set(val):
		if current_life == val: return
		if current_life - val <= 0.0:
			current_life = 0.0
			dead.emit()
			return

		current_life = minf(val, MAX_STAT_VALUE)
		health_changed.emit(current_life)


const MAX_GUTS: float = 100.0
const STARTING_GUTS: float = 50.0

var guts: float = STARTING_GUTS:
	set(val):
		guts = val
		guts_changed.emit(guts)

@export_range(5.0, 18.0, 1.0) var guts_rate: float = 13.0:
	set(val):
		guts_rate = clampf(val, 5.0, 50.0)
		guts_per_minute = (30.0 / guts_rate) * 60.0 if guts_rate else 99999.9

var guts_per_minute: int

@export var techniques: Array[Technique] =[]




func reset_combat_stats() -> void:
	guts = STARTING_GUTS
	current_life = life


func _validate_property(property: Dictionary) -> void:
	match property.name:
		&"max_life", &"life", &"power", &"speed", &"skill", &"defense", &"guts", &"guts_per_minute":
			property.usage |= 4 | PROPERTY_USAGE_READ_ONLY if Engine.is_editor_hint() or (property.name == &"guts_per_minute") else 4

