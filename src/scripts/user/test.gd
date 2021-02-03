extends Node 

func loop(rover):
	var mineables = rover.detect_mineables()
	while true:
		while not rover.is_in_mine_range(mineables[0]):
			var move_vect = mineables[0].global_position - rover.global_position
			var vec_sign = move_vect.sign()
			if abs(move_vect.x) > 10:
				move_vect.x = 10
			else:
				move_vect.x = 0
			if abs(move_vect.y) > 10:
				move_vect.y = 10
			else:
				move_vect.y = 0
			move_vect = move_vect * vec_sign
			#print(move_vect)
			rover.move_horizontally(move_vect.x, true) 
			rover.move_vertically(move_vect.y, true)
		while rover.mine(mineables[0]):
			pass
		if not rover.is_storage_full():
			break
		while not rover.is_in_mine_range(rover.res_bin):
			var move_vect = rover.res_bin.global_position - rover.global_position
			var vec_sign = move_vect.sign()
			if abs(move_vect.x) > 10:
				move_vect.x = 10
			else:
				move_vect.x = 0
			if abs(move_vect.y) > 10:
				move_vect.y = 10
			else:
				move_vect.y = 0
			move_vect = move_vect * vec_sign
			#print(move_vect)
			rover.move_horizontally(move_vect.x, true) 
			rover.move_vertically(move_vect.y, true)
		rover.loadout()
