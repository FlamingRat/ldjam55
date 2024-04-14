extends Area3D


@export var attack_damage: int = 5
var faction_self: Alignment.Faction:
	get:
		return get_parent().get_node('Alignment').faction


func attack_any():
	for area in get_overlapping_areas():
		var body = area.get_parent()
		if body == self:
			continue

		var alignment: Alignment = body.get_node('Alignment')
		if not alignment or alignment.faction != faction_self:
			var health = body.get_node('Health')
			if not (health is Health):
				continue

			print('Attacking ', body)
			health.damage(attack_damage)
			return true

	return false
