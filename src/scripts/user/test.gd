extends Node 

func loop(rover):
	var mineables = rover.detect_mineables()
	print(rover.is_in_mine_range(mineables[0]))
	if not rover.is_in_mine_range(mineables[0]):
		var move_vect = mineables[0].global_position - rover.global_position
		print(move_vect)
		rover.move_horizontally(move_vect.x, true) 
		rover.move_vertically(move_vect.y, true)
	while rover.mine(mineables[0]):
		pass
	#var collision = funcref(self, "collision_handler")
	#rover.move_horizontally(100)
	#rover.move_vertically(290, false, collision) # W razie kolizji obsłuż kolizje a potem przerwij
	#rover.move_horizontally(-100)
	
func collision_handler(rover):
	rover.move_horizontally(-100, false) # cofnij się z kolizji
