extends Node 

func loop(rover):
	var collision = funcref(self, "collision_handler")
	rover.move_horizontally(100)
	rover.move_vertically(290, false, collision) # W razie kolizji obsłuż kolizje a potem przerwij
	rover.move_horizontally(-100)
	
func collision_handler(rover):
	rover.move_horizontally(-100, false) # cofnij się z kolizji
