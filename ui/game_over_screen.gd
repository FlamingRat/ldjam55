extends CanvasLayer


func _ready():
	GlobalEvents.game_over.connect(func(): visible = true)
