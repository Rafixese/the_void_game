extends YSort


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	# CONSOLE SETUP
	var console = preload("res://scripts/console/console_commands.gd")
	console = console.ConsoleCommands.new()
	console.register_commands()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
