extends Label


func _process(_delta):
    var game_over = Store.state.game_state == Store.GameState.GAME_OVER
    if game_over and Input.is_action_just_pressed("confirm"):
        get_tree().change_scene_to_file('res://levels/main_menu.tscn')
