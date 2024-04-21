extends Label


func _process(_delta):
    var score: int = Store.state.kill_counter
    text = "Total Score: {score}
Turns survived: {turns}".replace('{score}', str(score)).replace('{turns}', str(Store.state.round_counter))
