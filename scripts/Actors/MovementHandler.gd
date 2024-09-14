@tool
@icon("res://art/UI/ClassIcons16x16/character_move.png")
class_name MovementHandler extends AbstractComponent
const GROUP: StringName = &"Movement"


signal move(to_global_position: Vector2)

var move_started: Signal = Signal()
var move_ended: Signal = Signal()


var node: Node2D
var anim: AnimationPlayer

@export var max_move_speed: float = 192.0

@export_range(0.0, 1.0, 0.025, "suffix:sec") 
var accleration_time: float = 1.0

@export_custom(0, "suffix:px/sec", PROPERTY_USAGE_EDITOR)
var current_speed: float = 0.0

@export var movement_modifier: float = 1.0

@export var is_moving: bool = false: set = set_is_moving

@export var can_move: bool = true: set = set_can_move

@export var target_global_position: Vector2: set = set_target_global_position
@export var accleration_trans: Tween.TransitionType = Tween.TransitionType.TRANS_LINEAR
@export var accleration_ease: Tween.EaseType = Tween.EaseType.EASE_IN

func _process(delta: float) -> void:
	if Engine.is_editor_hint() or target_global_position == node.global_position:
		set_is_moving(false)
		return
	# Tween.interpolate_value(
	var effective_max_speed: float = max_move_speed * movement_modifier
	var t: float = clampf(inverse_lerp(0.0, effective_max_speed, current_speed) + delta, 0.0, 1.0)
	current_speed = Tween.interpolate_value(0.0, effective_max_speed, t, accleration_time, accleration_trans, accleration_ease)

	
	move.emit(node.global_position.move_toward(target_global_position, current_speed * delta))

func move_position(pos: Vector2, t: float = 1.0) -> void:
	create_tween().tween_property(node, ^"global_position", pos, t)


func _enter_tree() -> void:
	if Engine.is_editor_hint(): return
	node = get_parent()
	move_started = Signal(add_signal("move_started", node, [ {"name": "target_pos", "type": TYPE_VECTOR2}]))
	move_ended = Signal(add_signal("move_ended", node))
	move.connect(node.set_global_position)
	
func clear_target() -> void:
	target_global_position = node.global_position
	set_is_moving(false)


func set_is_moving(val: bool) -> void:
	if Engine.is_editor_hint() or not can_move:
		is_moving = false
		return

	var movment_changed: bool = is_moving != val
	is_moving = val
	set_process(is_moving)
	if not is_moving:
		current_speed = 0.0
		if movment_changed: move_ended.emit()
	elif node.global_position != target_global_position and movment_changed:
		move_started.emit(target_global_position)
	

func set_target_global_position(pos: Vector2) -> void:
	if not is_inside_tree():
		await tree_entered
	printt("Target Position: ", pos)
	target_global_position = pos
	if target_global_position != node.global_position:
		set_is_moving(true)


func set_can_move(val: bool) -> void:
	if not is_inside_tree():
		await tree_entered
	can_move = val
	is_moving = target_global_position != node.global_position


func _exit_tree() -> void:
	if Engine.is_editor_hint(): return
	move.disconnect(node.set_global_position)
	remove_signal("move_started", node)
	remove_signal("move_ended", node)
	move_started = Signal()
	move_ended = Signal()
	node = null
