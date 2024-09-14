@tool
class_name Combatant extends Node2D

enum Anim {RESET, ATTACK, DIE, FALL, IDLE, JUMP, RUN, WALK}
enum MoveState {NONE = 0, RUN = 1, WALK = 2}


signal move_started
signal move_finished

signal attack(attack: Attack, target: Combatant)

signal attack_started
signal attack_finished


signal dead


@export_group("Nodes")
@export var anim: AnimationPlayer:
	set(val):
		anim = val
		update_configuration_warnings()
@export var combat_handler: CombatHandler:
	set(val):
		combat_handler = val
		update_configuration_warnings()
@export var target: Combatant

@export_category("Combatant Properties")
@export var stats: Stats = Stats.new()

## width of combatant, used for position/animation purposes
@export_range(0.0, 128.0, 2.0, "suffix:px", "or_greater") 
var width: float = 32.0

@export var animation_locked: bool

@export var is_dead: bool:
	set(val):
		is_dead = val
		if is_dead: dead.emit()



@export_range(0.0, 200.0, 5.0, "or_greater", "suffix:px/s") 
var default_speed: float = 192.0

@export var is_moving: bool: set = set_is_moving

var movement_tween: Tween: set = set_movement_tween


## Called every process frame in combat. 
func combat_tick(delta: float, locked: bool = false) -> void:
	pass


func play_animation(anim_name: StringName) -> void:
	if anim and not animation_locked and \
	anim.current_animation != anim_name and \
	anim.has_animation(anim_name):
		anim.play(anim_name)


#region Movement


func move_to_position(pos: Vector2, speed: float = default_speed) -> void:
	new_tween().tween_property(self, ^"position", pos, position.distance_to(pos) / speed)


func move_in_direction(dir: Vector2, speed: float = default_speed) -> void:
	new_tween().set_loops().tween_property(self, ^"position", dir.normalized() * 1.0, 1.0 / speed).as_relative()


func _on_move_finished() -> void:
	is_moving = false


func kill_tween(tw: Tween, ) -> void:
	if tw and tw.is_valid(): tw.kill()


func stop_movement() -> void:
	kill_tween(movement_tween)
	is_moving = false


func new_tween() -> Tween:
	kill_tween(movement_tween)
	movement_tween = create_tween()
	return movement_tween


func set_movement_tween(val: Tween) -> void:
	if movement_tween == val: return
	kill_tween(movement_tween)
	movement_tween = val
	val.finished.connect(_on_move_finished)


func set_is_moving(val: bool) -> void:
	is_moving = val
	var params := [&"move_started", &"run"] if is_moving else [&"move_finished", &"idle"]
	emit_signal(params[0])
	anim.play(params[1])


#endregion


#region Properties

func _get_property_list() -> Array[Dictionary]:
	var props: Array[Dictionary] = [ {name = "Animation", type = TYPE_NIL, usage = PROPERTY_USAGE_CATEGORY}]
	if anim:
		props.append(
			{
				name=&"current_animation",
				type=TYPE_STRING,
				hint=PROPERTY_HINT_ENUM_SUGGESTION,
				hint_string=",".join(anim.get_animation_list()),
			})

	return props


func _set(property: StringName, value: Variant) -> bool:
	match property:
		&"current_animation":
			if anim and value != anim.current_animation:
				anim.play(value)
		  
		_:
			return false
	return true

func _get(property: StringName) -> Variant:
	match property:
		&"current_animation":
			return anim.current_animation if anim and anim.current_animation else ""

	return null

func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()
	if not anim:
		warnings.append("'anim' is null.")
	if not combat_handler:
		warnings.append("'combat_handler' is null.")
	return warnings

#endregion
