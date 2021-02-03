extends Label

func _ready():
  set_process_input(true)#this will activate input handeling

func _input(event): # will get called on every input event
  #now we check if a random button got pressed:
  if event.is_pressed() and event.type == InputEvent.KEY and not event.is_echo():
	var val=int(self.get_text()) #get current value and convert  to int for math
	self.set_text(str(val+1))#add one and convert back to string, set label text
