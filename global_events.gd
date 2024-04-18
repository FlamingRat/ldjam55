extends Node


const TURN_TIME: float = 5


enum PlayerState {
    WALKING,
    SUMMONING,
    GAME_OVER,
}


signal next_turn(unit: Node3D)
signal next_turn_announced(unit: Node3D)
signal attack(attacker: AttackRange, health: Health)
signal kill
signal game_over
signal new_game


var round_count: int = 0
var level_size = Vector2(21, 15)
var timer = TURN_TIME
var units = []
var current_turn: int = 0
var current_turn_unit: Node3D:
    get:
        if not len(units):
            return

        if current_turn > len(units) - 1:
            current_turn = 0

        return units[current_turn]
var player_state = PlayerState.WALKING


func _ready():
    game_over.connect(end_game)
    new_game.connect(start_game)


func start_game():
    player_state = PlayerState.WALKING


func end_game():
    player_state = PlayerState.GAME_OVER


func end_turn():
    current_turn += 1

    next_turn_announced.emit(current_turn_unit)


func start_turn():
    if current_turn == 0:
        round_count += 1

    next_turn.emit(current_turn_unit)
    Store.dispatch(Store.Action.ANNOUNCE_TURN, current_turn_unit)


func register_unit(unit: Node3D):
    units.append(unit)
    unit.tree_exiting.connect(func(): unregister_unit(unit))


func unregister_unit(unit: Node3D):
    var alignment = unit.get_node('Alignment')

    if alignment and alignment.faction != Alignment.Faction.VAMPER:
        kill.emit()

    units.remove_at(units.find(unit))
