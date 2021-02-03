extends Node2D

var dragging = false  # Are we currently dragging?

var selected = []  # Array of selected units.

var drag_start = Vector2.ZERO  # Location where drag began.

var select_rect = RectangleShape2D.new()  # Collision shape for drag box.

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if event.pressed:
			# We only want to start a drag if there's no selection.

			if selected.size() == 0:
				dragging = true
				drag_start = event.position
		elif dragging:
			dragging = false
			update()
			var drag_end = event.position
			select_rect.extents = (drag_end - drag_start) / 2# Button released while dragging.
			var space = get_world_2d().direct_space_state
			var query = Physics2DShapeQueryParameters.new()
			query.set_shape(select_rect)
			query.transform = Transform2D(0, (drag_end + drag_start) / 2)
			selected = space.intersect_shape(query)
			print(selected)

			dragging = false
	if event is InputEventMouseMotion and dragging:
		update()

func _draw():
	if dragging:
		draw_rect(Rect2(drag_start, get_global_mouse_position() - drag_start),
				Color(.5, .5, .5), false)
				
export(NodePath) var gui_path = "GUI"
var health := 100
onready var gui = get_node(gui_path)




func _on_Building1_pressed():
	pass # Replace with function body.
