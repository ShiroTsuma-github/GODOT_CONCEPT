extends TextureRect

@export var display_weight: bool = false
@export var position_index: int = 0 :
	get:
		return position_index
	set(value):
		position_index = value
		update_visual_data.emit()
@export var weight_index: int = 0 :
	get:
		return weight_index
	set(value):
		weight_index = value
		update_visual_data.emit()
@export var weight: float = 0 :
	get:
		return weight
	set(value):
		weight = value
		update_visual_data.emit()
		weight_history.append(value)

var weight_history: Array = [weight]

@onready var center = get_node('Area2D').global_position

signal update_visual_data

# Called when the node enters the scene tree for the first time.
func _ready():
	print(center)
	name = "Perceptron"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func set_weight_index(value):
	weight_index = value

func set_position_index(value):
	position_index = value

func set_weight(value):
	weight = value


