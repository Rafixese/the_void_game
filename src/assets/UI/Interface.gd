extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_res_bin_global_storage_changed():
	$Iron/Label.text = "{amount}".format({"amount": get_tree().get_root().find_node("World", true, false).global_storage["test_resource"]})
