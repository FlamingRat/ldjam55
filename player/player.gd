extends Node3D
class_name Player


@export var summon_units: Array[PackedScene]
@export var movement_speed: int
@export var mana: int = 1
@export var mana_regen: int = 1
@export var summon_range: int = 2
@onready var notify_sfx := $NotifySFX
@onready var movement := $CharacterMovementController
@onready var summons := $SummonController
@onready var collision_detector := $CollisionDetector
@onready var steps_available = movement_speed
@onready var current_mana = mana
var summon_slot: int


var actions = {
    "move_up": move_up,
    "move_down": move_down,
    "move_left": move_left,
    "move_right": move_right,
    "summon1": func(): start_summon(0),
    "summon2": func(): start_summon(1),
    "confirm": end_turn,
}


func _process(_delta):
    if Store.state.current_turn_unit == self:
        turn_input_listener()


func _on_character_turn_listener_on_turn():
    steps_available = movement_speed
    if current_mana and mana_regen:
        current_mana = min(current_mana + mana_regen, mana)

    if notify_sfx:
        notify_sfx.play()


func turn_input_listener():
    for action in actions:
        if not Input.is_action_just_pressed(action):
            continue

        actions[action].call()


func start_summon(new_summon_slot: int):
    if not current_mana or GlobalEvents.player_state != GlobalEvents.PlayerState.WALKING:
        return

    GlobalEvents.player_state = GlobalEvents.PlayerState.SUMMONING
    summon_slot = new_summon_slot
    summons.start_summon()


func summon(pos: Vector3):
    GlobalEvents.player_state = GlobalEvents.PlayerState.WALKING
    var inst_unit: Node3D = summon_units[summon_slot].instantiate()
    get_parent().add_child(inst_unit)
    inst_unit.global_position = pos
    current_mana -= 1


func move_up():
    if not steps_available or GlobalEvents.player_state != GlobalEvents.PlayerState.WALKING:
        return

    if not movement.movement_allowed(Vector3.FORWARD):
        return

    movement.move(Vector3.FORWARD)
    steps_available -= 1


func move_down():
    if not steps_available or GlobalEvents.player_state != GlobalEvents.PlayerState.WALKING:
        return

    if not movement.movement_allowed(Vector3.BACK):
        return

    movement.move(Vector3.BACK)
    steps_available -= 1


func move_left():
    if not steps_available or GlobalEvents.player_state != GlobalEvents.PlayerState.WALKING:
        return

    if not movement.movement_allowed(Vector3.LEFT):
        return

    movement.move(Vector3.LEFT)
    steps_available -= 1


func move_right():
    if not steps_available or GlobalEvents.player_state != GlobalEvents.PlayerState.WALKING:
        return

    if not movement.movement_allowed(Vector3.RIGHT):
        return

    movement.move(Vector3.RIGHT)
    steps_available -= 1


func end_turn():
    if GlobalEvents.player_state == GlobalEvents.PlayerState.WALKING:
        Store.dispatch(Store.Action.END_TURN)


func _on_health_health_depleted():
    Store.dispatch(Store.Action.TRIGGER_GAME_OVER)
    queue_free()
