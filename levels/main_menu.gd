extends Control


func _process(_delta):
	if Input.is_action_just_pressed("confirm"):
		GlobalEvents.new_game.emit()
		get_tree().change_scene_to_file('res://levels/overworld.tscn')
