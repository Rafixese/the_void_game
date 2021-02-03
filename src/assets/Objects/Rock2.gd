extends StaticBody2D


var __resource = null

func _ready():
	add_to_group("mineable")
	__resource = load("res://assets/resources/test_resource.gd")
	__resource = __resource.new()

func mine():
	return __resource.mine()
	
func get_resource_type():
	return __resource.RESOURCE_TYPE
	
func get_resource_amount_left():
	return __resource.get_amount()
