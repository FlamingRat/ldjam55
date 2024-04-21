extends Node
class_name BattleLogReducer


static func announce_turn(state: Store.State, message: Store.Message) -> Store.State:
    var unit: Node3D = message.payload
    if unit is Spawner:
        return state

    state.battle_log += '\n' + unit_name(unit) + "'s turn!"
    return state


static func unit_name(unit: Node3D):
    var char_turn: CharacterTurnListener = unit.get_node('CharacterTurnListener')
    var name = char_turn.unit_name if char_turn else unit.name
    return name


static func announce_attack(state: Store.State, message: Store.Message) -> Store.State:
    var attack = message.payload
    var attacker_name = unit_name(attack.attacker)
    var target_name = unit_name(attack.target)
    state.battle_log += '\n' + attacker_name + ' attacks ' + target_name + '!'
    return state


static func announce_kill(state: Store.State, message: Store.Message) -> Store.State:
    var unit_name: String = message.payload
    state.battle_log += '\n' + unit_name + ' died!'
    state.kill_counter += 1
    return state
