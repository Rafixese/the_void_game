extends Node2D

#console helpers
var choosen_rover

func _ready():
	# CONSOLE SETUP
	register_commands()
	
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
