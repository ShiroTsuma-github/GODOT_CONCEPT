extends Button

var layer_count: int = 1

signal create_layer_setup
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_pressed():
	create_layer_setup.emit()


func _on_spin_box_value_changed(value):
	layer_count = value
