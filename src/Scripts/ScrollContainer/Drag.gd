extends ScrollContainer

var mouse_button_down = false
var previous_pos = Vector2(0, 0)
var difference = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
		

func _on_gui_input(event):
	if (event is InputEventMouseButton):
		if (event.button_index == MOUSE_BUTTON_LEFT):
			mouse_button_down = event.pressed
			previous_pos = event.position
	
	if (event is InputEventMouseMotion and mouse_button_down == true):
		print(event.position[0] - previous_pos[0] + difference)
		scroll_vertical += (event.position[0] - previous_pos[0] + difference) * 2
		difference = event.position[0] - previous_pos[0]
		previous_pos = event.position
		
				

