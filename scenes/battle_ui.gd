@tool
@icon("res://art/UI/ClassIcons16x16/ui_toolbar.png")
class_name BattleUI extends Control

@export_range(0.1, 2.0, 0.1, "suffix:sec") var life_tween_sec: float = 0.7
@export var life_trans: Tween.TransitionType = Tween.TRANS_LINEAR
@export var life_ease: Tween.EaseType = Tween.EASE_IN_OUT

# @export_range(0.1, 2.0, 0.1, "suffix:sec") var guts_tween_sec: float = 0.4
# @export var life_trans: Tween.TransitionType = Tween.TRANS_LINEAR
# @export var life_ease: Tween.EaseType = Tween.EASE_IN_OUT

@export_group("Nodes")
@export var life_left: ProgressBar:
	set(val):
		life_left = val
		update_configuration_warnings()
@export var life_right: ProgressBar:
	set(val):
		life_right = val
		update_configuration_warnings()

@export var guts_left: TextureProgressBar:
	set(val):
		guts_left = val
		update_configuration_warnings()
@export var guts_right: TextureProgressBar:
	set(val):
		guts_right = val
		update_configuration_warnings()



func _init() -> void:
	if not Engine.is_editor_hint():
		visible = false


func init_combatants(player: Combatant, opponent: Combatant) -> void:
	bind_stats(player.stats, life_left, guts_left)
	bind_stats(opponent.stats, life_right, guts_right)


func bind_stats(stats: Stats, life: ProgressBar, guts: TextureProgressBar) -> void:
	life.max_value = stats.life
	life.value = stats.current_life
	guts.max_value = stats.MAX_GUTS
	guts.value = stats.guts

	stats.health_changed.connect(_on_health_change.bind(life))
	stats.guts_changed.connect(_on_guts_changed.bind(guts))


func _on_health_change(val: float, bar: ProgressBar) -> void:
	create_tween().set_trans(life_trans).set_ease(life_ease).tween_property(bar, ^"value", val, life_tween_sec)
	
func _on_guts_changed(val: float, bar: ProgressBar) -> void:
	bar.value = val

func tween_value() -> void:
	pass



func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()
	for prop: StringName in [&"life_left", &"life_right", &"guts_left", &"guts_right"]:
		if not get(prop): warnings.append("'%s is null." % prop)
	return warnings
