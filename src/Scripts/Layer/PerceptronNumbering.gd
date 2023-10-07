extends MarginContainer

@export var start_index: int = 0
@export var base_children_count: int = 0
@onready var layer = get_child(0)
var base_perceptron = load("res://src/Scenes/Perceptron.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	var index = start_index
	create_perceptrons()
	for perceptron in layer.get_children():
		perceptron.position_index = index
		index += 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func create_perceptrons():
	for _i in range(base_children_count):
		add_perceptron()

func add_perceptron():
	var new_perceptron = base_perceptron.instantiate()
	new_perceptron.position_index = start_index + layer.get_child_count()
	new_perceptron.display_weight = false
	layer.add_child(new_perceptron)
