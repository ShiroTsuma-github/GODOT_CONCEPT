extends Area2D

var isHovering: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed and isHovering:
			print("A click!")
			print(global_position)


func _on_mouse_entered():
	isHovering = true


func _on_mouse_exited():
	isHovering = false
