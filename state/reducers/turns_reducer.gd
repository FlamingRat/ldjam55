extends Node
class_name TurnsReducer


enum TurnStatus {
    ACTION,
    TRANSITION,
}


static func register_unit(state: Store.State, message: Store.Message) -> Store.State:
    var unit: Node3D = message.payload
    var alignment: Alignment = unit.get_node("Alignment")
    if not alignment:
        printerr('Missing Alignment for registered unit ', unit)

    if alignment.faction == Alignment.Faction.CROSS:
        state.enemy_units.append(unit)
    else:
        state.allied_units.append(unit)

    unit.tree_exiting.connect(func(): Store.dispatch(Store.Action.UNREGISTER_UNIT, unit))
    return state


static func unregister_unit(state: Store.State, message: Store.Message) -> Store.State:
    var unit: Node3D = message.payload
    var alignment = unit.get_node('Alignment')

    if not alignment:
        printerr('Missing Alignment for registered unit ', unit)
        
    var ref: Array[Node3D]
    if alignment.faction == Alignment.Faction.VAMPER:
        ref = state.allied_units
    else:
        ref = state.enemy_units

    var slot: int = ref.find(unit)
    ref.remove_at(slot)
    
    var global_slot: int = state.units.find(unit)
    if global_slot > state.turn_counter:
        return state

    state.turn_counter -= 1
    return state


static func end_turn(state: Store.State, message: Store.Message) -> Store.State:
    state.turn_counter += 1
    if state.turn_counter >= len(state.units):
        state.turn_counter = 0
        state.round_counter += 1

    state.camera_focus = state.current_turn_unit.global_position
    state.turn_status = TurnStatus.TRANSITION
    return state


static func start_turn(state: Store.State, message: Store.Message) -> Store.State:
    state.turn_status = TurnStatus.ACTION
    return state
