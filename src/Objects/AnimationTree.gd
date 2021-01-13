extends AnimationTree

var playback : AnimationNodeStateMachinePlayback

func _ready():
	playback = get("parameters/playback")
	playback.start("stay")
	active=true
	
func _process(delta):
	if Input.is_action_just_pressed("ui_down"):
		playback.travel("ride")
	if Input.is_action_just_pressed("ui_up"):
		playback.travel("stay")
	print(playback.get_current_node())
