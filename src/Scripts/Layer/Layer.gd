@tool
extends MarginContainer

@onready var layer = get_child(0)

@export var start_index: int = 0
@export var children_count: int = 0 :
	get:
		return children_count
	set(value):
		children_count = value

var added_count: int = 0
var perceptrons: Array = []
var center = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	var index = start_index
	create_perceptrons()
	for perceptron in layer.get_children():
		perceptron.position_index = index
		index += 1
	print(perceptrons)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func create_perceptrons():
	for _i in range(children_count):
		add_perceptron()

# Function to add new perceptron object to layer
func add_perceptron():
	# Instantiate loaded object
	var new_perceptron = Objects.Base_Perceptron.instantiate()
	new_perceptron.position_index = start_index + perceptrons.size()
	perceptrons.append(new_perceptron)
	layer.add_child(new_perceptron)

func remove_perceptron():
	# 	Remove last perceptron from layer
	# tu not sure czy tak usunie, bo pop_back zwraca, ale czy wchodzi queue_free
	perceptrons.pop_back().queue_free()
	
