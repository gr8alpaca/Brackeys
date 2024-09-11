@tool
@icon("res://art/UI/ClassIcons16x16/swords.png")
class_name Dueler extends Node

@export
var party: Array[Combatant] = []

@export
var opponents: Array[Combatant] = []


func declare_attack(attack: Attack) -> void:
	assert(is_attack_valid(attack), "invalid attack submitted")


func get_defender(attack: Attack) -> Combatant:
	return null


func is_attack_valid(attack: Attack) -> bool:
	return attack != null and attack.attacker != null and attack.stats != null and attack.technique != null
	

# ((Attack Level +1)*Force)/3 
func get_base_damage(stats: Stats, tech: Technique) -> float:
	return ((stats.power + 1.0) * tech.force) / 3.0

# (Attack Level-1-((2*(Defense Level-1))+Defender Attack Level-1)/3)*10+100
func get_damage_adjustment(attacker: Stats, defender: Stats) -> float:
	return (attacker.power - 1.0 - ((2.0 * (attacker.defense - 1.0)) + defender.power - 1.0) / 3.0) * 10.0 + 100.0


func calculate_damage(attack: Attack) -> float:
	assert(attack.defender != null, "No attack defender!")
	var base: float = get_base_damage(attack.stats, attack.technique)
	var adjustment: float = get_damage_adjustment(attack.def_stats, attack.att_stats)
	return base * adjustment / 100.0
