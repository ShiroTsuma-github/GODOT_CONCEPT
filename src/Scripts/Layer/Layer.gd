@tool
extends MarginContainer

@onready var layer = get_child(0)

@export var start_index: int = 0
@export var children_count: int = 0 :
	get:
		return children_count
	set(value):
		children_count = value
		if Engine.is_editor_hint():
			var layer = get_child(0)
			recalc_perceptron_count()

var base_perceptron = load("res://src/Scenes/Perceptron.tscn")
var added_count: int = 0

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
	for _i in range(children_count):
		add_perceptron()

# Function to add new perceptron object to layer
func add_perceptron():
	# Instantiate loaded object
	var new_perceptron = base_perceptron.instantiate()
	new_perceptron.position_index = start_index + layer.get_child_count()
	layer.add_child(new_perceptron)

func remove_perceptron():
	# var children = layer.get_children()
	# 	Remove last perceptron from layer
	layer.get_children()[layer.get_child_count() - 1].queue_free()

func recalc_perceptron_count():
	if layer == null:
		return
	var diff = children_count + added_count - layer.get_child_count()
	for _i in range(diff):
		add_perceptron()
		return
	
	if diff < 0:
		diff = -diff
		for _i in range(diff):
			remove_perceptron()
	