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
var input_count: int = 0
var output_count: int = 0

	
	# NEURAL NETWORK IMPLEMENTATION
	
func init(i_layer_type, i_left_layer, i_right_layer, i_pos_x):
	pos_x = i_pos_x
	layer_type = i_layer_type
	left_layer = i_left_layer
	right_layer = i_right_layer
	
var pos_x: int
var children = []
var layer_type: Objects.LayerTypes
var right_layer = []
var left_layer = []
var children_functions = []
var results = []

func clear_all():
	results = []
	for child in children:
		child.clear_all()

func calc_outputs():
	var ans = []
	for i in children.size():
		ans.append(children[i].get_set_output())
	results = ans

func calc_errors(data=null):
	var errors_ = []
	for obj in children:
		errors_.append(obj.calc_error(data))
	return Objects.sum(errors_)

func forward_output():
	for i in children.size():
		right_layer.children[i].output = results[i]
	right_layer.results = results

func child_count():
	return children.size()

func prepare_for_backpropagation():
	for i in children.size():
		children[i].set_right_neighbours(right_layer.children)

func add_children(i_children):
	children = i_children
	for i in children.size():
			children[i].pos_x = pos_x
			children[i].pos_y = i
			if i_children[i].type == 'perceptron':
				children_functions.append(children[i].activation_function)
				if left_layer != null:
					children[i].set_neighbours(left_layer.children)

func cadd_child(i_child):
	children.append(i_child)
	if i_child.type == 'perceptron':
		children_functions.append(i_child.activation_function)
		children[-1].set_neighbours(left_layer.children)
		children[-1].set_pos(pos_x, children.size() - 1)
	layer.add_child(i_child)

func get_sums():
	var res = []
	for i in children.size():
		res.append(children[i].calc_sum())
	return res

func randomize_weights(ten=false):
	for i in children.size():
		if ten:
			children[i].randomize_weights_around_10()
		else:
			children[i].randomize_weights_around_1()

func zero_weights():
	for i in children.size():
		children[i].zero_weights()

func update_children_weights():
	for i in children.size():
		children[i].update_weights()

func set_children_functions(i_activation_function):
	var temp = []
	for i in children.size():
		temp.append(i_activation_function)
		children[i].activation_function = i_activation_function
	children_functions = temp

func set_child_weights(i_pos_y, i_weights):
	children[i_pos_y].weights = i_weights

func set_children_weights(i_weights):
	for i in i_weights.size():
		set_child_weights(i, i_weights[i])

func set_children_functions_by_list(i_activation_functions):
	var temp = []
	for i in children.size():
		temp.append(i_activation_functions[i])
		children[i].activation_function = i_activation_functions[i]
	children_functions = temp
	
func set_child_function(i_pos_y, i_activation_function):
	children_functions[i_pos_y] = i_activation_function
	children[i_pos_y].activation_function = i_activation_function

func get_children_functions():
	return children_functions

func is_running(run):
	for i in children.size():
		children[i].is_running(run)
