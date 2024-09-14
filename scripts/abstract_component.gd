@tool
@icon("res://art/UI/ClassIcons16x16/page_voxel.png")
class_name AbstractComponent extends Node

func add_signal(signal_name: StringName, node: Node, args: Array = []) -> Signal:
	if not signal_name in node:
		node.add_user_signal(signal_name, args)
	return Signal(node, signal_name)
	
func remove_signal(signal_name: StringName, node: Node) -> void:
	if node.has_user_signal(signal_name):
		node.remove_user_signal(signal_name)

func get_group() -> StringName:
	return get(&"GROUP") if &"GROUP" in self else &"AbstractComponent"


func _notification(what: int) -> void:

	match what:

		NOTIFICATION_POSTINITIALIZE when not name:
			name = get_group()

		NOTIFICATION_PARENTED:
			get_parent().set_meta(get_group(), self)
			
		NOTIFICATION_EXIT_TREE:
			get_parent().remove_meta(get_group())
