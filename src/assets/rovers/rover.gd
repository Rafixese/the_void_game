extends KinematicBody2D

class_name Rover


const MAX_SPEED = 200
const ACCELERATION = 1000
const FRICTION = 1000

var velocity = Vector2.ZERO
var input_movement = Vector2.ZERO

var collision_objects = []
var warning_indicator_sprite

var target_radius = 50  # Stop when this close to target.
var target = null setget set_target  # Set this to move.
var selected = false setget set_selected  # Is this unit selected?

var user_script


# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("rovers")
	get_node("Label").set_text(get_name())
	warning_indicator_sprite = get_node("warning")
	warning_indicator_sprite.visible = false
	
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
