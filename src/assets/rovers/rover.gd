extends KinematicBody2D

class_name Rover


const MAX_SPEED = 200
const ACCELERATION = 1000
const FRICTION = 1000

var velocity = Vector2.ZERO
var input_movement = Vector2.ZERO

var user_script


# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("rovers")
	
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
	
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		
	velocity = move_and_slide(velocity)

func move_horizontally(x_offset):
	var destination_pos = global_position.x + x_offset
	if x_offset > 0:
		input_movement.x = 1
		while(global_position.x < destination_pos):
			pass
	else:
		input_movement.x = -1
		while(global_position.x > destination_pos):
			pass
	input_movement.x = 0
