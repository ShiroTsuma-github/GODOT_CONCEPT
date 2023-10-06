extends TextureRect

@export var display_weight: bool = false
@export var layer: int = 0
@export var layer_pos: int = 0 : 
	get:
		return layer_pos
	set(value):
		layer_pos = value
		update_visual_data.emit()
@export var weight: float = 0

signal update_visual_data

# Called when the node enters the scene tree for the first time.
func _ready():
	name = "Perceptron"
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func set_layer_pos(value):
	layer_pos = value

func set_layer(value):
	layer = value

func set_weight(value):
	weight = value


