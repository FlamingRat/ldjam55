extends Camera3D


var follow: Node3D
@onready var default_position = global_position


func _ready():
    follow = GlobalEvents.current_turn_unit

    
func _process(_delta):
    if follow != Store.state.current_turn_unit:
        focus(Store.state.current_turn_unit)

    if follow and not follow.is_queued_for_deletion():
        global_position = default_position + follow.global_position


func focus(unit: Node3D):
    follow = null
    var pos_delta = unit.global_position
    
    if (global_position - (default_position + pos_delta)).length() > 4:
        var tween_fov = create_tween()
        tween_fov.set_ease(Tween.EASE_OUT)
        tween_fov.tween_property(self, 'fov', 90, 0.5)
        await get_tree().create_timer(0.5).timeout
    
    var tween_pos = create_tween()
    var tween_fov75 = create_tween()
    tween_pos.tween_property(self, 'global_position', default_position + pos_delta, 0.75)
    tween_fov75.tween_property(self, 'fov', 75, 0.75)
    await get_tree().create_timer(1).timeout

    allow_next_turn(unit)


func allow_next_turn(unit = null):
    if weakref(unit).get_ref() and not unit.is_queued_for_deletion():
        follow = unit
