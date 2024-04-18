extends Node
class_name CharacterTurnListener


signal on_turn


@export var unit_name: String


func _ready() -> void:
    GlobalEvents.next_turn.connect(on_next_turn)
    GlobalEvents.register_unit(get_parent())
    Store.update.connect(func(state: Store.State): print(Store.state.units))
    Store.dispatch(Store.Action.REGISTER_UNIT, get_parent())


func on_next_turn(unit):
    if unit == get_parent():
        on_turn.emit()
