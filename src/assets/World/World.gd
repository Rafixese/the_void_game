extends Node2D

#console helpers
var choosen_rover

var dragging = false  # Are we currently dragging?
var selected = []  # Array of selected units.
var drag_start = Vector2.ZERO  # Location where drag began.
var drag_stop = Vector2.ZERO
var select_rect = RectangleShape2D.new()  # Collision shape for drag box.
var can_place_tower = false
var invalid_tiles
var building = StaticBody2D.new()

signal global_storage_changed

onready var rectd = $Node2D/selection
onready var tower = load("res://assets/Objects/Building1.tscn")

var global_storage = {"test_resource": 100}

func _ready():
	# CONSOLE SETUP
	register_commands()
	emit_signal("global_storage_changed")
	invalid_tiles = $TileMap.get_used_cells()
	
func _process(delta):
	if dragging:
		draw_area(drag_start, get_global_mouse_position())
	else:
		draw_area(Vector2.ZERO, Vector2.ZERO, false)
	
func _unhandled_input(event):
	var camera_position = $YSort/Player/Camera2D.get_camera_screen_center() - get_viewport_rect().size / 2
	if event is InputEventMouseMotion and can_place_tower:
		$tower_placement.clear()
		var tile = $tower_placement.world_to_map(event.position + camera_position)
		
		if not tile in invalid_tiles:
			$tower_placement.set_cell(tile.x, tile.y, 1)
		else:
			$tower_placement.set_cell(tile.x, tile.y, 0)
	
	elif event is InputEventMouseButton and can_place_tower and event.pressed:
		var tile = $tower_placement.world_to_map(event.position + camera_position)
		print(tile.x, ", ", tile.y)
		
		if not tile in invalid_tiles:
			can_place_tower = false
			$tower_placement.clear()
			global_storage["test_resource"] -= 100
			emit_signal("global_storage_changed")
			invalid_tiles.append(tile)
			
			var tower_instance = tower.instance()
			tower_instance.position = tile
			tower_instance.position.x+=tile.x*31
			tower_instance.position.y+=tile.y*31
			$YSort.add_child(tower_instance)
	
	elif event is InputEventMouseButton and event.button_index == BUTTON_LEFT: 
		if event.pressed:
			dragging = true
			drag_start = event.position
			drag_start.x += camera_position.x
			drag_start.y += camera_position.y
		elif dragging:
			dragging = false
			update()
			var drag_end = event.position
			drag_end.x += camera_position.x
			drag_end.y += camera_position.y
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

func draw_area(startv, endv, s = true):
	rectd.rect_size = Vector2(abs(startv.x-endv.x), abs(startv.y - endv.y))
	
	var pos = Vector2()
	pos.x = min(startv.x, endv.x)
	pos.y = min(startv.y, endv.y)
	rectd.rect_position = pos
	
	rectd.rect_size *= int(s) # true = 1 and false = 0

	
func register_commands():
	Console.add_command('print_rovers', self, 'print_rovers')\
			.set_description('Prints rovers in current scene')\
			.register()
	Console.add_command('choose_rover', self, 'choose_rover')\
			.set_description('Picks and saves rover object for further actions. Takes one argument, which is %name%')\
			.add_argument('name', TYPE_STRING)\
			.register()
	Console.add_command('print_choosen_rover', self, 'print_choosen_rover')\
			.set_description('Prints name of choosen rover')\
			.register()
	Console.add_command('execute_rover_script', self, 'execute_rover_script')\
			.set_description('Executes rover user script')\
			.register()
	Console.add_command('set_user_script', self, 'set_user_script')\
			.set_description('Sets user script for choosen rover. Takes %name% parameter, without extension or path.')\
			.add_argument('name', TYPE_STRING)\
			.register()
	Console.add_command('spawn_rover', self, 'spawn_rover')\
			.set_description('Spawns rover. Takes 1 argument: %name% - name of node.')\
			.add_argument('name', TYPE_STRING)\
			.register()
	
func print_rovers():
	var rovers = get_tree().get_nodes_in_group("rovers")
	for child in rovers:
		Console.write_line(child.get_name())

func choose_rover(name):
	var rovers = get_tree().get_nodes_in_group("rovers")
	var rover = null
	for child in rovers:
		if child.get_name() == name:
			rover = child
	
	if rover == null:
		Console.write_line("Couldn't find rover with name {name}".\
			format({"name":name}))
	else:
		choosen_rover = rover
	
func print_choosen_rover():
	if choosen_rover == null:
		Console.write_line("There is no rover selected")
	else:
		Console.write_line(choosen_rover.get_name())

func execute_rover_script():
	choosen_rover.user_script_execute()

func set_user_script(name):
	choosen_rover.set_user_script(name)
	
func spawn_rover(name):
	var new_rover = load("res://assets/rovers/rover.tscn")
	new_rover = new_rover.instance()
	new_rover.set_name(name)
	var rand = RandomNumberGenerator.new()
	rand.randomize()
	var x_offset = rand.randf_range(-50, 50)
	rand.randomize()
	var y_offset = rand.randf_range(-5, 5)
	new_rover.position.x = 9741 + x_offset
	new_rover.position.y = 9493 + y_offset
	add_child_below_node(self.get_node("rovers_y_sort"), new_rover)
	
	

func supply(supplies):
	var world = get_tree().get_root().find_node("World", true, false)
	for key in supplies:
		world.global_storage[key] += supplies[key]
	print(world.global_storage)
	emit_signal("global_storage_changed")
	
func _on_Building1_pressed():
	$tower_placement.clear()
	if global_storage["test_resource"] > 99:
		can_place_tower = !can_place_tower
