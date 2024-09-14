@tool
class_name Attack extends RefCounted




signal attack_started

signal hit(attack_result: int)
signal damaged(amount: float)

signal attack_finished

var technique: Technique

var attacker: Combatant
var att_stats: Stats

var defender: Combatant:
    set(val):
        defender = val
        def_stats = defender.stats if defender else null

var def_stats: Stats

enum {NONE = 0, DAMAGED, MISSED, BLOCKED}
var result: int = NONE

func set_attacker(attacker: Combatant) -> Attack:
    self.attacker = attacker
    att_stats = attacker.stats
    return self

func set_defender(defender: Combatant) -> Attack:
    self.defender = defender
    def_stats = defender.stats
    return self

func set_technique(technique: Technique) -> Attack:
    self.technique = technique
    return self

