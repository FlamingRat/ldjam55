extends Area3D
class_name AttackRange


@export var attack_damage: int = 5
var faction_self: Alignment.Faction:
	get:
		return get_parent().get_node('Alignment').faction


func attack_any():
	for area in get_overlapping_areas():
		var body = area.get_parent()
		if body == self or not (area is Hitbox):
			continue

		var alignment: Alignment = body.get_node('Alignment')
		if alignment and alignment.faction == faction_self:
			continue

		var health = body.get_node('Health')
		if not (health is Health):
			continue

		print('Attacking ', body)
		health.damage(attack_damage)
		GlobalEvents.attack.emit(self, health)
		return true

	return false
