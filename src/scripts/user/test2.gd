extends Node 

func loop(rover):
	while not rover.is_in_mine_range(rover.res_bin):
		var move_vect = rover.res_bin.global_position - rover.global_position
		if move_vect.x > 10:
			move_vect.x = 10
		else:
			move_vect.x = 0
		if move_vect.y > 10:
			move_vect.y = 10
		else:
			move_vect.y = 0
		print(move_vect)
		rover.move_horizontally(move_vect.x, true) 
		rover.move_vertically(move_vect.y, true)
