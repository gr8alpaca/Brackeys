@tool
@icon("res://art/UI/ClassIcons16x16/character_question.png")
class_name Logic extends Resource

signal request_attack(tech: Technique)

enum {SUCCESS, FAILURE, RUNNING}

@export_range(0.0, 5.0, 0.25, "or_greater", "suffix:sec")
var min_attack_delay: float = 1.0

var attack_delay_timer: float = 0.0



func _init() -> void:
	if Engine.is_editor_hint:
		resource_local_to_scene = true



func tick(delta: float, combat_handler: CombatHandler) -> void:
	pass