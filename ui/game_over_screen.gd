extends CanvasLayer


func _process(_delta):
    visible = Store.state.game_state == Store.GameState.GAME_OVER
