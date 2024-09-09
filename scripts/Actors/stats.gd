class_name Stats extends Resource

signal health_changed(health_delta: float)

@export_range(10.0, 200.0, 5.0, "or_greater", "or_less") var base_health: float = 20.0
@export_range(1.0, 20.0, 1.0, "or_greater", "or_less") var base_attack: float = 10.0
@export_range(1.0, 20.0, 1.0,  "or_greater", "or_less") var base_defense: float = 10.0


var health: float = 20.0
var attack: float = 10.0
var defense: float = 10.0





# func _set(property: StringName, value: Variant) -> bool:
#     if "base" in property:
