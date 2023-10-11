extends Area2D

var isHovering: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed and isHovering:
			Objects.create_inspector.emit()


func _on_mouse_entered():
	isHovering = true


func _on_mouse_exited():
	isHovering = false
