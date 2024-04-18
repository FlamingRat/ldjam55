extends Area3D
class_name AttackRange


class Attack:
    var attacker: Node3D
    var target: Node3D


    func _init(attacker, target):
        self.attacker = attacker.get_parent()
        self.target = target.get_parent()


@export var animator: AnimationTree
@export var attack_damage: int = 5
@onready var hit_sound := $AudioStreamPlayer
var faction_self: Alignment.Faction:
    get:
        return get_parent().get_node('Alignment').faction


func attack_any():
    for area in get_overlapping_areas():
        var body = area.get_parent()
        if body == self or not (area is Hitbox) or not weakref(body).get_ref():
            continue

        var alignment: Alignment = body.get_node('Alignment')
        if alignment and alignment.faction == faction_self:
            continue

        var health = body.get_node('Health')
        if not (health is Health) or not (health as Health).current_health:
            continue

        GlobalEvents.attack.emit(self, health)
        var attack: Attack = Attack.new(self, health)
        Store.dispatch(Store.Action.ANNOUNCE_ATTACK, attack)
        health.damage(attack_damage)
        hit_sound.play()

        if animator:
            animator.set('parameters/attack/request', AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
            await get_tree().create_timer(1).timeout

        return true

    return false
