@icon("res://art/UI/ClassIcons16x16/laser.png")
@tool
class_name Technique extends Resource
# enum {TIER_E, TIER_D, TIER_C , TIER_B, TIER_A, TIER_S}

@export var name: String

@export var icon: Texture2D

@export_range(5, 70, 1, ) var cost: int = 15

@warning_ignore("shadowed_global_identifier")
@export_range(1, 3, 1, "hide_slider")
var range: int = 1

@export_range(1.0, 50.0, 1.0, "or_greater")
var force: float = 30.0

@export_range(5.0, 30.0, 1.0, "or_greater", "or_less")
var sharp: float = 10.0

@export_range(-20.0, 20.0, 1.0, "or_greater", "or_less")
var hit: float = -3.0

# TODO: Wither

func get_rating(prop: StringName) -> String:
	match prop:

		&"force":
			if 49 < force: return "S"
			if 39 < force: return "A"
			if 29 < force: return "B"
			if 19 < force: return "C"
			if 9 < force: return "D"

		&"hit":
			if 13 < hit: return "S"
			if 4 < hit: return "A"
			if 0 < hit: return "B"
			if -5 < hit: return "C"
			if -15 < hit: return "D"

		&"sharp":
			if 29 < sharp: return "S"
			if 24 < sharp: return "A"
			if 19 < sharp: return "B"
			if 14 < sharp: return "C"
			if 9 < sharp: return "D"

	return "E"
			

func _validate_property(property: Dictionary) -> void:
	match property.name:
		&"force", &"hit", &"sharp":
			var rating := "suffix:" + get_rating(property.name)
			property.hint_string += ("," + rating) if property.hint_string else rating