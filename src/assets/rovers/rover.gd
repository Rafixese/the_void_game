extends KinematicBody2D

class_name Rover

var storage = {"test_resource": 0}

const MAX_SPEED = 200
const ACCELERATION = 1000
const FRICTION = 1000

const MINEABLE_DIST = 100
const INVENTORY_SIZE = 10

var velocity = Vector2.ZERO
var input_movement = Vector2.ZERO

var collision_objects = []
var warning_indicator_sprite

var target_radius = 50  # Stop when this close to target.
var target = null setget set_target  # Set this to move.
var selected = false setget set_selected  # Is this unit selected?

var user_script

var res_bin


# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("rovers")
	get_node("Label").set_text(get_name())
	warning_indicator_sprite = get_node("warning")
	warning_indicator_sprite.visible = false
	res_bin = get_tree().get_root().find_node("res_bin", true, false)
	print(res_bin.global_position)
	
func set_selected(value):
	# Draw a highlight around the unit if it's selected.
	selected = value
	if selected:
		$Sprite.material.set_shader_param("aura_width", 1)
	else:
		$Sprite.material.set_shader_param("aura_width", 0)
		
func set_target(value):
	target = value
	
func set_user_script(name):
	user_script = load("res://scripts/user/{name}.gd".format({"name":name}))
	user_script = user_script.new()
	
func user_script_execute():
	var thread = Thread.new()
	thread.start(self, "__user_script_execute_thread", self)
	
func __user_script_execute_thread(context):
	user_script.loop(context)


func _physics_process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = input_movement.x
	input_vector.y = input_movement.y
	input_vector = input_vector.normalized()
	
	if target:
		# If there's a target, move toward it.
		velocity = position.direction_to(target)
		if position.distance_to(target) < target_radius:
			target = null
			
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		
	velocity = move_and_slide(velocity)
	
	var collisions = []
	
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		collisions.push_back(collision)
	
	collision_objects = collisions
	
	if !collision_objects.empty():
		warning_indicator_sprite.visible = true
	else:
		warning_indicator_sprite.visible = false

func move_horizontally(x_offset, cancel_on_collision=true, on_collision = null):
	var destination_pos = global_position.x + x_offset
	if x_offset > 0:
		input_movement.x = 1
		while(global_position.x < destination_pos):
			if !collision_objects.empty():
				if on_collision != null:
					on_collision.call_func(self)
					input_movement.x = 1
				if cancel_on_collision:
					break
	else:
		input_movement.x = -1
		while(global_position.x > destination_pos):
			if !collision_objects.empty():
				if on_collision != null:
					on_collision.call_func(self)
					input_movement.x = -1
				if cancel_on_collision:
					break
	input_movement.x = 0
	
func move_vertically(y_offset, cancel_on_collision = true, on_collision = null):
	var destination_pos = global_position.y + y_offset
	if y_offset > 0:
		input_movement.y = 1
		while(global_position.y < destination_pos):
			if !collision_objects.empty():
				if on_collision != null:
					on_collision.call_func(self)
					input_movement.y = 1
				if cancel_on_collision:
					break
	else:
		input_movement.y = -1
		while(global_position.y > destination_pos):
			if !collision_objects.empty():
				if on_collision != null:
					on_collision.call_func(self)
					input_movement.y = -1
				if cancel_on_collision:
					break
	input_movement.y = 0
	
func detect_mineables():
	var mineables = []
	var bodies = $Area2D.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("mineable"):
			print(body.name)
			print(body.global_position.x)
			print(body.global_position.y)
			mineables.append(body)
	return mineables
			
func is_in_mine_range(mineable_obj):
	var distance = global_position.distance_to(mineable_obj.global_position)
	if distance <= MINEABLE_DIST:
		return true
	else:
		return false

func is_storage_full():
	var sum = 0
	for item in storage:
		sum += storage[item]
	
	return sum >= INVENTORY_SIZE

func mine(mineable_obj):
	if not is_storage_full():
		if is_in_mine_range(mineable_obj):
			if mineable_obj.mine():
				print("Mining 1 resource \'{resource_type}\'. {amount} unit(s) left.".format({"resource_type": mineable_obj.get_resource_type(), "amount": mineable_obj.get_resource_amount_left()}))
				OS.delay_msec(1000)
				storage[mineable_obj.get_resource_type()] += 1
				print("Now I have {amount} of {resource_type} in my inventory :D".format({"resource_type": mineable_obj.get_resource_type(), "amount": storage[mineable_obj.get_resource_type()]}))
				return true
			else:
				print("Can't mine.")
				return false
		else:
			print("Not in range.")
			return false
	else:
		print("Storage is full.")
		return false

func loadout():
	if is_in_mine_range(res_bin):
		print("LOADOUT!")
		print(storage)
		res_bin.supply(storage)
		for key in storage:
			storage[key] = 0
	else:
		print("Not in range.")
		return false
