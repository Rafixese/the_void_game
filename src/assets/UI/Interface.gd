extends Control

func _ready():
	pass # Replace with function body.

func _on_res_bin_global_storage_changed():
	$Iron/Label.text = "{amount}".format({"amount": get_tree().get_root().find_node("World", true, false).global_storage["test_resource"]})
