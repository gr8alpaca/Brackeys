@tool
class_name Combatant extends Node2D

enum Anim {RESET, ATTACK, DIE, FALL, IDLE, JUMP, RUN, WALK}

@export var stats: Stats = Stats.new()
# @export var current_animation: Anim = Anim.IDLE: set = set_animation_state

@export_group("Nodes")
@export var anim: AnimationPlayer
@export var ui: Control


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
          
    return false


func _get(property: StringName) -> Variant:
    match property:
        &"current_animation":
            return anim.current_animation if anim and anim.current_animation else ""

    return null