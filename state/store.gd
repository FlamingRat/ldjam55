extends Node
class_name StoreType


enum Action {
    START_GAME,
    REGISTER_UNIT,
    UNREGISTER_UNIT,
    ANNOUNCE_TURN,
    ANNOUNCE_ATTACK,
    ANNOUNCE_KILL,
    START_TURN,
    END_TURN,
    TRIGGER_GAME_OVER,
    RETURN_TO_MAIN_MENU,
    UPDATE_CAMERA_POSITION,
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


class Level:
    extends Node
    
    var size: Vector2 = Vector2(21, 15)


class State:
    extends Node

    var game_state: GameState = GameState.MAIN_MENU
    var battle_log: String = "Vamper's turn!"
    var round_counter: int = 0
    var kill_counter: int = 0
    var allied_units: Array[Node3D] = []
    var enemy_units: Array[Node3D] = []
    var turn_counter: int = 0
    var turn_status: TurnsReducer.TurnStatus = TurnsReducer.TurnStatus.TRANSITION
    var level: Level = Level.new()
    var camera_focus: Vector3 = Vector3.ZERO
    var units: Array[Node3D]:
        get:
            var arr: Array[Node3D] = []
            arr.append_array(allied_units)
            arr.append_array(enemy_units)
            return arr
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
    Action.ANNOUNCE_KILL: BattleLogReducer.announce_kill,
    Action.REGISTER_UNIT: TurnsReducer.register_unit,
    Action.UNREGISTER_UNIT: TurnsReducer.unregister_unit,
    Action.START_TURN: TurnsReducer.start_turn,
    Action.END_TURN: TurnsReducer.end_turn,
    Action.TRIGGER_GAME_OVER: game_over,
    Action.RETURN_TO_MAIN_MENU: main_menu,
    Action.UPDATE_CAMERA_POSITION: CameraReducer.update_camera_position,
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
    return state


func game_over(state: State, message: Message) -> State:
    state.game_state = GameState.GAME_OVER
    return state


func main_menu(state: State, message: Message) -> State:
    return State.new()
