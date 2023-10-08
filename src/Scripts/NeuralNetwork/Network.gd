extends HBoxContainer
var base_perceptron_layer = load("res://src/Scenes/Layer.tscn")
var perceptron_layer_count: int = 0
var perc_per_layer: Array = []
var perceptron_count: int= 1 
@onready var MainScene = get_tree().root.get_child(0)

# Called when the node enters the scene tree for the first time.
func _ready():
	setup()

func setup():
	print(perc_per_layer)
	for i in range(perceptron_layer_count):
		add_layer(perc_per_layer[i])

func add_layer(value=1):
	var layer = base_perceptron_layer.instantiate()
	layer.children_count = value
	layer.start_index = perceptron_count
	perceptron_count += value
	add_child(layer)
	perceptron_layer_count += 1

func remove_layer():
	get_children()[get_child_count() - 1].queue_free()
	perceptron_layer_count -= 1
