extends Node

var __amount = 100

func mine():
	if __amount > 0:
		__amount -= 1
		return true
	else:
		return false
		
func get_amount():
	return __amount
