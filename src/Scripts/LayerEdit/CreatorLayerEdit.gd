extends HBoxContainer
@export var perceptron_count: int = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_spin_box_value_changed(value):
	perceptron_count = value
