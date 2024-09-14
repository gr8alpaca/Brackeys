@tool
@icon("res://art/UI/ClassIcons16x16/sword_eye.png")
class_name Conductor extends Node

@export var player: Combatant
@export var opponent: Combatant

@export var dueler: Dueler

@export_category("Phantom Cameras")
@export var follow_cam: PhantomCamera2D
@export var battle_cam: PhantomCamera2D
@export var attack_cam: PhantomCamera2D


func _ready() -> void:
	if Engine.is_editor_hint(): return

	player.move_to_position(player.global_position + Vector2(opponent.global_position.x - CombatHandler.MAX_DISTANCE, 0.0))
	player.move_finished.connect(follow_cam.queue_free)
	player.move_finished.connect(start_combat, CONNECT_DEFERRED)


func start_combat() -> void:
	pass


#region Warnings

func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()

	if not player:
		warnings.append("'player' is null.")

	if not opponent:
		warnings.append("'opponent' is null.")

	if not dueler:
		warnings.append("'dueler' is null.")

	if not follow_cam:
		warnings.append("'follow_cam' is null.")

	if not battle_cam:
		warnings.append("'battle_cam' is null.")

	if not attack_cam:
		warnings.append("'attack_cam' is null.")

	return warnings

#endregion
