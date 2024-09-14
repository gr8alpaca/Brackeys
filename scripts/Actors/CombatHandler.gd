@tool
@icon("res://art/UI/ClassIcons16x16/sword_start.png")
class_name CombatHandler extends AbstractComponent
const GROUP: StringName = &"CombatHandler"

const MIN_DISTANCE: float = 40.0
const MAX_DISTANCE: float = 456.0

signal debug_changed(show_debug: bool)

signal attack(att: Attack)
signal move(pos: Vector2)
signal play_animaton(animation_name: StringName)
signal state_changed(new_state: State)

var combatant: Combatant:
	set(val):
		combatant = val
		if Engine.is_editor_hint(): return
		stats = combatant.stats
		guts_per_second = 30.0 / stats.guts_rate
		techniques = stats.techniques


var stats: Stats

var target: Combatant


var techniques: Array[Technique]

var guts_per_second: float

@export var debug: bool: set = set_debug

		
				

@export_range(10.0, 96.0, 2.00, "suffix:px")
var max_wander_length: float = 32.0

@export_range(32.0, 156.0, 2.0, "suffix:px/s", "or_greater")
var wander_speed: float = 0.3

enum State{IDLE, ATTACKING, DEFENDING, DEAD}
var state: State = State.IDLE:
	set(val):
		state = val
		state_changed.emit(state)

var is_attacking: bool

enum {NONE, TOWARDS, AWAY}
var previous_wander_direction: int = NONE
var wander_vector: Vector2


@export var position_locked: bool:
	set(val):
		position_locked = val
		if position_locked:
			wander_vector = Vector2.ZERO
			previous_wander_direction = NONE


func tick(delta: float, ) -> void:
	if not is_attacking: 
		stats.guts += guts_per_second * delta

	if position_locked:
		return


#region Movement


func idle_wander(delta: float) -> void:
	
	if not wander_vector: wander_vector = get_random_vector()
	var length_delta: float = wander_speed * delta 
	var position_delta: Vector2 = wander_vector.normalized() * length_delta
	wander_vector = wander_vector.move_toward(Vector2.ZERO, length_delta)
	move.emit(combatant.position + position_delta)
	# combatant.position 


func get_random_vector() -> Vector2:
	var target_delta: Vector2 = target.position - combatant.position

	var forced_dir: int = TOWARDS if abs(target_delta.x )> MAX_DISTANCE else NONE
	if abs(target_delta.x) < MIN_DISTANCE: 
		forced_dir = AWAY
	
	var dir: Vector2 = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)) if not forced_dir else Vector2.ZERO
	if forced_dir:
		dir = Vector2(randf()*sign(target_delta.x), randf_range(-1.0, 1.0))
		if forced_dir == AWAY:
			dir.x *= (-1)
	
	return dir * max_wander_length * randf_range(0.6, 1.1)


#endregion


#region tree enter/exit


func _enter_tree() -> void:
	combatant = get_parent()
		
	if Engine.is_editor_hint():
		if "combat_handler" in combatant and combatant.combat_handler != self: combatant.combat_handler = self
		return


	if &"stats" in combatant:
		stats = combatant.stats
		techniques = stats.techniques
	

	var move_callable: Callable = Callable(combatant, "set_position")
	var animation_callable: Callable = Callable(combatant, "play_animation")
	
	if move_callable.is_valid() and not move.is_connected(move_callable):
		move.connect(move_callable)
	
	if animation_callable.is_valid() and not play_animaton.is_connected(animation_callable):
		play_animaton.connect(animation_callable)
	

func _exit_tree() -> void:
	if Engine.is_editor_hint(): return
	stats = null

	for sig: Signal in [move, play_animaton]:
		for dict in sig.get_connections():
			sig.disconnect(dict["callable"])

#endregion


#region Debug


func set_debug(val: bool) -> void:
	if debug == val: return
	debug = val
	const LABEL_NAME: StringName = &"CombatHandlerDebug"

	match [debug, combatant.has_node(NodePath(LABEL_NAME))]:

		[true, false]:
			var label:= Label.new()
			label.name = LABEL_NAME
			label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			update_debug_label(state, label)
			combatant.add_child(label, true)
			label.position -=  Vector2(label.size.x/2.0,label.size.y/2.0 + 64.0) 
			state_changed.connect(update_debug_label.bind(label))

		[false, true]:
			if state_changed.is_connected(update_debug_label): state_changed.disconnect(update_debug_label)
			combatant.get_node(NodePath(LABEL_NAME)).queue_free()


func update_debug_label(state: State, label: Label) -> void:
	label.text = State.find_key(state)	


#endregion
