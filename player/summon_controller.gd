extends Node
class_name SummonController


var summon_controls = {
	"ui_up": up,
	"ui_down": down,
	"ui_left": left,
	"ui_right": right,
	"ui_accept": confirm_summon,
}


@export var summon_indicator: PackedScene
@export var sfx: AudioStreamPlayer
@onready var player: Player = get_parent()
var indicator: Node3D
var frame_lock = false


func _process(_delta):
	var summoning = GlobalEvents.player_state == GlobalEvents.PlayerState.SUMMONING
	if not summoning or frame_lock:
		frame_lock = false
		return

	for action in summon_controls:
		if not Input.is_action_just_pressed(action):
			continue

		summon_controls[action].call()


func start_summon(pos: Vector3):
	frame_lock = true
	indicator = summon_indicator.instantiate()
	player.add_child(indicator)
	indicator.position = pos


func up():
	var intent = indicator.position + Vector3.FORWARD
	if intent.length() >= player.summon_range:
		return

	indicator.position = intent


func down():
	var intent = indicator.position + Vector3.BACK
	if intent.length() >= player.summon_range:
		return

	indicator.position = intent


func left():
	var intent = indicator.position + Vector3.LEFT
	if intent.length() >= player.summon_range:
		return

	indicator.position = intent


func right():
	var intent = indicator.position + Vector3.RIGHT
	if intent.length() >= player.summon_range:
		return

	indicator.position = intent


func confirm_summon():
	player.summon(player.global_position + indicator.position)
	indicator.queue_free()
	indicator = null
	sfx.play()
