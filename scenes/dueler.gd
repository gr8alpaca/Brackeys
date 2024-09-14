@tool
@icon("res://art/UI/ClassIcons16x16/swords.png")
class_name Dueler extends Node

var player: Combatant:
	set(val):
		player = val
		player_combat = player.combat_handler
var opponent: Combatant:
	set(val):
		opponent = val
		opponent_combat = opponent.combat_handler

var player_combat: CombatHandler
var opponent_combat: CombatHandler

func initialize_combatants(player: Combatant, opponent: Combatant) -> void:
	self.player = player
	player.opponent = opponent
	player_combat = player.combat_handler
	
	self.opponent = opponent
	opponent.opponent = player
	
	opponent_combat = opponent.combat_handler



func declare_attack(attack: Attack) -> void:
	assert(is_attack_valid(attack), "invalid attack submitted")
	

func is_attack_valid(attack: Attack) -> bool:
	return attack != null and attack.attacker != null and attack.stats != null and attack.technique != null
	

func calculate_damage(attack: Attack) -> float:
	var base: float = (((attack.attacker.stats.power + 1.0) * attack.technique.force) / 3.0)
	var adjustment: float = ((attack.attacker.stats.power - 1.0 - ((2.0 * (attack.attacker.stats.defense - 1.0)) + attack.defender.stats.power - 1.0) / 3.0) * 10.0 + 100.0)
	return base * adjustment / 100.0
