extends Camera3D


@export var wide_fov: float = 90
@export var narrow_fov: float = 75
@onready var default_position: Vector3 = global_position
var current_focus: Vector3 = Vector3.ZERO
var panning: bool = false


func _ready() -> void:
    Store.update.connect(_on_store_update)
    Store.dispatch(Store.Action.START_TURN)

    
func _process(_delta: float) -> void:
    if not panning:
        global_position = default_position + Store.state.camera_focus


func _on_store_update(state: Store.State) -> void:
    if state.camera_focus != current_focus:
        await pan(state.camera_focus)
    
    if Store.state.turn_status == TurnsReducer.TurnStatus.TRANSITION:
        Store.dispatch(Store.Action.START_TURN)


func pan(focus: Vector3) -> void:
    panning = true
    current_focus = focus

    var focus_delta: Vector3 = (global_position - (default_position + current_focus))
    if focus_delta.length() > 4:
        var tween_fov: Tween = create_tween()
        tween_fov.set_ease(Tween.EASE_OUT)
        await tween_fov.tween_property(self, 'fov', wide_fov, 0.5)
        await get_tree().create_timer(0.5).timeout

    var tween_pos: Tween = create_tween()
    var tween_fov75: Tween = create_tween()
    tween_pos.tween_property(self, 'global_position', default_position + current_focus, 0.75)
    tween_fov75.tween_property(self, 'fov', narrow_fov, 0.75)
    await get_tree().create_timer(1.5).timeout
    panning = false
