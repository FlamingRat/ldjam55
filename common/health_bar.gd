extends Sprite3D


@export var health: Health


func _process(delta):
	var percent = health.percent
	if percent != (texture as GradientTexture2D).width:
		var tween = create_tween()
		var new_scale = Vector3(percent, 1, 1)
		tween.tween_property(self, 'scale', new_scale, 0.4)
