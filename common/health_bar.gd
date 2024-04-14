extends Node3D


@export var health: Health
@onready var fill := $HealthBarFill


func _process(delta):
	var percent = health.percent
	if percent != (fill.texture as GradientTexture2D).width:
		var tween = create_tween()
		var new_scale = Vector3(percent, 1, 1)
		tween.tween_property(fill, 'scale', new_scale, 0.4)
