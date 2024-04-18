extends Node


enum Action {
    START_GAME,
    REGISTER_UNIT,
    UNREGISTER_UNIT,
    ANNOUNCE_TURN,
    ANNOUNCE_ATTACK,
    END_TURN,
    TRIGGER_GAME_OVER,
    RETURN_TO_MAIN_MENU,
}


class Message:
    var action: Action
    var payload: Variant

    func _init(action: Action, payload: Variant) -> void:
        self.action = action
        self.payload = payload


enum GameState {
    MAIN_MENU,
    RUNNING,
    GAME_OVER,
}


class State:
    extends Node

    var game_state: GameState = GameState.MAIN_MENU
    var battle_log: String = "Vamper's turn!"
    var round_counter: int = 0
    var units: Array[Node3D] = []
    var turn_counter: int = 0
    var current_turn_unit: Node3D:
        get:
            if not len(units):
                return null

            if turn_counter >= len(units):
                return units[0]

            return units[turn_counter]


signal update(state: State)
var state: State = State.new()
var reducers: Dictionary = {
    Action.START_GAME: start_game,
    Action.ANNOUNCE_TURN: BattleLogReducer.announce_turn,
    Action.ANNOUNCE_ATTACK: BattleLogReducer.announce_attack,
    Action.REGISTER_UNIT: TurnsReducer.register_unit,
    Action.UNREGISTER_UNIT: TurnsReducer.unregister_unit,
    Action.END_TURN: TurnsReducer.end_turn,
    Action.TRIGGER_GAME_OVER: game_over,
    Action.RETURN_TO_MAIN_MENU: main_menu,
}


func dispatch(action_name: Action, payload: Variant = null) -> void:
    var message: Message = Message.new(action_name, payload)
    var reducer: Callable = reducers[message.action]
    if not reducer:
        printerr('Undefined reducer for action ', action_name, '!')

    state = reducer.call(state, message)
    update.emit(state)


func start_game(state: State, message: Message) -> State:
    state.game_state = GameState.RUNNING
    state.turn_counter = 0
    return state


func game_over(state: State, message: Message) -> State:
    state.game_state = GameState.GAME_OVER
    return state


func main_menu(state: State, message: Message) -> State:
    state.game_state = GameState.MAIN_MENU
    return state
