extends VBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	var index = 0
	for perceptron in get_children():
		print(perceptron)
		perceptron.layer_pos = index
		index += 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func setup():
	pass
