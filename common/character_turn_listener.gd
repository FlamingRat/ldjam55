extends Node
class_name CharacterTurnListener


signal on_turn


@export var unit_name: String
var is_turn: bool = false


func _ready() -> void:
    Store.update.connect(on_next_turn)
    Store.dispatch(Store.Action.REGISTER_UNIT, get_parent())


func on_next_turn(state: Store.State):
    var next_frame_is_turn = state.current_turn_unit == get_parent()
    if next_frame_is_turn and not is_turn:
        print('next turn called for ', get_parent())
        is_turn = true
        on_turn.emit()
        return

    is_turn = next_frame_is_turn
