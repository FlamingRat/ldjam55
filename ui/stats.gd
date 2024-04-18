extends Label


var score = 0


func _ready():
    GlobalEvents.kill.connect(add_score)


func _process(_delta):
    text = "Total Score: {score}
Turns survived: {turns}".replace('{score}', str(score)).replace('{turns}', str(GlobalEvents.round_count))


func add_score():
    score += 1
