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
var isHovering: bool = false

@onready var center = get_node('Area2D').global_position

signal update_visual_data

# Called when the node enters the scene tree for the first time.
func _ready():
	name = "Perceptron"
	inner_neighbour.init(1)
	set_neighbours([1,3,2])
	



func set_weight_index(value):
	weight_index = value

func set_position_index(value):
	position_index = value

func set_weight(value):
	weight = value


func _on_area_2d_mouse_entered():
	isHovering = true


func _on_area_2d_mouse_exited():
	isHovering = false
	
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed and isHovering:
			# Objects.create_inspector.emit()
			Objects.perceptron_pressed.emit(self)


# NEURAL NETWORK IMPLEMENTATION
func init(
	i_activation_function, i_learning_rate, i_momentum,
	i_step_bipolar_threshold, i_identity_a,
	i_parametric_a, i_perc_x, i_perc_y):

		activation_function = i_activation_function
		learning_rate = i_learning_rate
		momentum = i_momentum
		step_bipolar_threshold = i_step_bipolar_threshold
		identity_a = i_identity_a
		parametric_a = i_parametric_a
		perc_x = i_perc_x
		perc_y = i_perc_y

func set_pos(i_perc_x, i_perc_y):
	perc_x = i_perc_x
	perc_y = i_perc_y


var activation_function: int
var inner_weight: float = 0
var learning_rate: float = 0.1
var momentum = 0
var step_bipolar_threshold = 0
var identity_a = 0
var parametric_a = 0.1
var perc_x: int
var perc_y: int
var weights = [inner_weight] :
	get:
		return weights
	set(value):
		previous_weights.append(weights)
		inner_weight = value[0]
		weights = value
		if len(previous_weights) > 50:
			previous_weights.pop_front()
var previous_weights = []
var output = 0:
	get:
		return output
	set(value):
		previous_outputs.append(output)
		output = value
		if len(previous_outputs) > 50:
			previous_outputs.pop_front()
var error = 0
var previous_difference = []
var previous_outputs = []
var inner_neighbour = Objects.Base_InputOutput.instantiate()
var velocity_weight = []
var left_neighbours = []
var right_neighbours = []


func modify_weights(expected_output, training_set):
	var new = []
	# TODO: IMPLEMENT MOMENTUM FOR SINGLE PERCEPTRON
	training_set = [1] + training_set
	for i in weights.size():
		new.append(weights[i] + training_set[i] * expected_output * learning_rate)
	weights = new

func update_weights():
	var new = []
	for i in weights.size():
		velocity_weight[i] = momentum * velocity_weight[i] + learning_rate  * error * left_neighbours[i].output
		new.append(weights[i] + velocity_weight[i])
	weights = new

func set_neighbours(neighbours):
	left_neighbours = [self.inner_neighbour] + neighbours
	previous_weights = []
	weights = Objects.mul_list(0, left_neighbours.size())
	velocity_weight = Objects.mul_list(0, weights.size())
	
func randomize_weights_around_1():
	var new = []
	var rng = RandomNumberGenerator.new()
	for i in weights.size():
		new.append(rng.randf_range(-1, 1))
	weights = new

func randomize_weights_around_10():
	var new = []
	var rng = RandomNumberGenerator.new()
	for i in weights.size():
		new.append(rng.randf_range(-10, 10))
	weights = new

func calc_error(expected_output=null):
	if expected_output == null:
		# TODO: Verify perc_y is correct and set
		error = (expected_output[perc_y] - output) * get_output_der()
	else:
		#.map(func(n): return n * 2)
		# var doubled = range(5).map(func(n): return n * 2)
		# TODO: Verify if it works
		error = Objects.sum(right_neighbours.map(func(n): return (n.error * n.weights[perc_y]))) * get_output_der()
	return error

func calc_sum():
	var sum_ = 0.0
	for i in weights.size():
		sum_ += left_neighbours[i].output * weights[i]
	return sum_

func set_right_neighbours(neighbours):
	right_neighbours = neighbours

func calc_step_unipolar():
	if calc_sum() > 0:
		return 1
	return 0

func calc_step_unipolar_der():
	# add signal that will show popup with error
	# for that create copy of network on start and if it fails first walkthrough, then load it, else clear
	# or just stop
	assert(1 == 2, "ERROR: STEP DOESN'T HAVE DERIVATIVE")

func calc_step_bipolar():
	if calc_sum() >= step_bipolar_threshold:
		return 1
	return -1

func calc_step_bipolar_der():
	assert(1 == 2, "ERROR: STEP DOESN'T HAVE DERIVATIVE")

func calc_identity():
	return identity_a * calc_sum()

func calc_identity_der():
	return identity_a

func calc_sigmoid_unipolar():
	return 1 / (1 + exp(-calc_sum()))

func calc_sigmoid_unipolar_der():
	var res = calc_sigmoid_unipolar()
	return res * (1 - res)

func calc_sigmoid_bipolar():
	return -1 + 2 / (1 + exp(-calc_sum()))

func calc_sigmoid_bipolar_der():
	var res = calc_sigmoid_bipolar()
	return 0.5 * (1 - res * res)

func calc_relu():
	return max(0, calc_sum())

func calc_relu_der():
	if calc_sum() >= 0:
		return 1
	return 0

func calc_relu_leaky():
	var sum_ = calc_sum()
	return max(0.01 * sum_, sum_)

func calc_relu_leaky_der():
	var sum_ = calc_sum()
	if sum_ >= 0:
		return 1
	return 0.01

func calc_relu_parametric():
	var sum_ = calc_sum()
	if sum_ > 0:
		return sum_
	return parametric_a * sum_

func calc_relu_parametric_der():
	var sum_ = calc_sum()
	if sum_ >= 0:
		return 1
	return parametric_a

func calc_softplus():
	return log(1 + exp(calc_sum()))

func calc_softplus_der():
	return 1 / (1 + exp(-calc_sum()))

func get_output():
	if activation_function == Objects.ActivationFunctions.IDENTITY:
		return calc_identity()
	elif activation_function == Objects.ActivationFunctions.RELU:
		return calc_relu()
	elif activation_function == Objects.ActivationFunctions.SIGMOID_BIPOLAR:
		return calc_sigmoid_bipolar()
	elif activation_function == Objects.ActivationFunctions.SIGMOID_UNIPOLAR:
		return calc_sigmoid_unipolar()
	elif activation_function == Objects.ActivationFunctions.SOFTPLUS:
		return calc_softplus()
	elif activation_function == Objects.ActivationFunctions.STEP_BIPOLAR:
		return calc_step_bipolar()
	elif activation_function == Objects.ActivationFunctions.STEP_UNIPOLAR:
		return calc_step_unipolar()
	elif activation_function == Objects.ActivationFunctions.RELU_LEAKY:
		return calc_relu_leaky()
	elif activation_function == Objects.ActivationFunctions.RELU_PARAMETRIC:
		return calc_relu_parametric()
	else:
		assert(1 == 2, "ERROR: COULD NOT MATCH ACTIVATION FUNCTION")

func get_set_output():
	output = get_output()
	return output

func get_output_der():
	if activation_function == Objects.ActivationFunctions.IDENTITY:
		return calc_identity_der()
	elif activation_function == Objects.ActivationFunctions.RELU:
		return calc_relu_der()
	elif activation_function == Objects.ActivationFunctions.SIGMOID_BIPOLAR:
		return calc_sigmoid_bipolar_der()
	elif activation_function == Objects.ActivationFunctions.SIGMOID_UNIPOLAR:
		return calc_sigmoid_unipolar_der()
	elif activation_function == Objects.ActivationFunctions.SOFTPLUS:
		return calc_softplus_der()
	elif activation_function == Objects.ActivationFunctions.STEP_BIPOLAR:
		return calc_step_bipolar_der()
	elif activation_function == Objects.ActivationFunctions.STEP_UNIPOLAR:
		return calc_step_unipolar_der()
	elif activation_function == Objects.ActivationFunctions.RELU_LEAKY:
		return calc_relu_leaky_der()
	elif activation_function == Objects.ActivationFunctions.RELU_PARAMETRIC:
		return calc_relu_parametric_der()
	else:
		assert(1 == 2, "ERROR: COULD NOT MATCH ACTIVATION FUNCTION")
