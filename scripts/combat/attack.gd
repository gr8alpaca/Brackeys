@tool
class_name Attack extends RefCounted


var technique: Technique

var attacker: Combatant:
    set(val):
        attacker = val
        att_stats = attacker.stats if attacker else null

var att_stats: Stats

var defender: Combatant:
    set(val):
        defender = val
        def_stats = defender.stats if defender else null

var def_stats: Stats


func set_info(attacker: Combatant = null, technique: Technique = null) -> Attack:
    if attacker:
        self.attacker = attacker
    if technique:
        self.technique = technique
    return self