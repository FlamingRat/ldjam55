extends Node3D


@onready var indicator := $MeshInstance3D


func _process(_delta):
	var parent: Player = get_parent()
	if not (parent is Player):
		return

	var mesh: TorusMesh = indicator.mesh
	var can_walk = parent.steps_available and parent.turn_actions
	var radius = parent.steps_available + 0.5 if can_walk else 0.0
	
	if radius == mesh.outer_radius:
		return

	var intween = create_tween()
	var outtween = create_tween()
	intween.tween_property(mesh, "inner_radius", radius -0.1, 0.4)
	outtween.tween_property(mesh, "outer_radius", radius, 0.4)
