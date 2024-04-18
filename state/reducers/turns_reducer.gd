extends Node
class_name TurnsReducer


static func register_unit(state: Store.State, message: Store.Message) -> Store.State:
    var unit: Node3D = message.payload
    state.units.append(unit)
    unit.tree_exiting.connect(func(): Store.dispatch(Store.Action.UNREGISTER_UNIT, unit))
    return state


static func unregister_unit(state: Store.State, message: Store.Message) -> Store.State:
    var unit: Node3D = message.payload
    var alignment = unit.get_node('Alignment')

    #if alignment and alignment.faction != Alignment.Faction.VAMPER:
        #kill.emit()

    var slot = state.units.find(unit)
    state.units.remove_at(slot)
    if slot > state.turn_counter:
        return state

    state.turn_counter -= 1
    return state


static func end_turn(state: Store.State, message: Store.Message) -> Store.State:
    state.turn_counter += 1
    if state.turn_counter >= len(state.units):
        state.turn_counter = 0
        state.round_counter += 1

    return state
