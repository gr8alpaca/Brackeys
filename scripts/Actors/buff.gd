@icon("res://art/UI/ClassIcons16x16/character_edit.png")
@tool
class_name Buff extends Resource

@export var name: String

@export_color_no_alpha 
var text_color: Color = Color.GREEN_YELLOW

@export var icon: Texture

var combatant: Combatant
var stats: Stats


func add_buff() -> void:
    pass

func remove_buff() -> void:
    pass