@tool
class_name Battle extends Node2D

@export var cam: Camera2D
@export var party: Node2D
@export var player: Combatant

@export var scroll_speed: float = 10.0


func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if Engine.is_editor_hint(): return
	var move_amount: float = scroll_speed * delta
	# if cam:
		# cam.position.x += move_amount
	if party:
		party.position.x += move_amount
