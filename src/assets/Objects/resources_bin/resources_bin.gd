extends StaticBody2D


signal global_storage_changed

func supply(supplies):
	var world = get_tree().get_root().find_node("World", true, false)
	for key in supplies:
		world.global_storage[key] += supplies[key]
	print(world.global_storage)
	emit_signal("global_storage_changed")
