extends Node
class_name CharacterTurnListener


signal on_turn


@export var unit_name: String
var is_turn: bool = false


static func of(parent: Node3D) -> CharacterTurnListener:
    return parent.get_node('CharacterTurnListener')


func _ready() -> void:
    Store.update.connect(_on_next_turn)
    Store.dispatch(Store.Action.REGISTER_UNIT, get_parent())


func _on_next_turn(state: Store.State) -> void:
    var action: bool = state.turn_status == TurnsReducer.TurnStatus.ACTION
    var next_frame_is_turn: bool = state.current_turn_unit == get_parent()
    var go: bool = next_frame_is_turn and action and get_parent().is_node_ready()
    if go and not is_turn:
        print('next turn called for ', get_parent())
        is_turn = true
        on_turn.emit()
        return

    is_turn = go
