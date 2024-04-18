extends Node


enum Action {
    START_GAME,
    REGISTER_UNIT,
    ANNOUNCE_TURN,
    ANNOUNCE_ATTACK,
}


class Message:
    var action: Action
    var payload: Variant

    func _init(action: Action, payload: Variant) -> void:
        self.action = action
        self.payload = payload


enum ScreenState {
    MAIN_MENU,
    GAME,
}


enum GameState {
    STOPPED,
    RUNNING,
}


class State:
    extends Node

    var screen_state: ScreenState = ScreenState.MAIN_MENU
    var game_state: GameState = GameState.STOPPED
    var battle_log: String = "Vamper's turn!"
    var turn_counter: int = 0
    var units: Array[Node3D] = []


signal update(state: State)
var state: State = State.new()
var reducers: Dictionary = {
    Action.START_GAME: start_game,
    Action.REGISTER_UNIT: register_unit,
    Action.ANNOUNCE_TURN: BattleLogReducer.announce_turn,
    Action.ANNOUNCE_ATTACK: BattleLogReducer.announce_attack,
}


func dispatch(action_name: Action, payload: Variant) -> void:
    var message: Message = Message.new(action_name, payload)
    state = reducers[message.action].call(state, message)
    update.emit(state)


func start_game(state: State, message: Message) -> State:
    state.game_state = GameState.RUNNING
    state.turn_counter = 0
    return state


func register_unit(state: State, message: Message) -> State:
    var unit: Node3D = message.payload
    state.units.append(unit)
    return state
