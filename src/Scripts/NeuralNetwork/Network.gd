extends HBoxContainer
var base_perceptron_layer = load("res://src/Scenes/Layer.tscn")
var perceptron_layer_count: int = 0
var perc_per_layer: Array = []
var perceptron_count: int = 1 
var ginput_count: int = 1
var goutput_count: int = 1
@onready var MainScene = get_tree().root.get_child(0)
var glayers: Array = []
var start_left: int = 60
var start_top = 100
var diff_x = 160
var diff_y = 130
var offset_x = 40
var selected_x = null
var selected_y = null
var forward_dir = true

# Called when the node enters the scene tree for the first time.
func _ready():
	
	
	Objects.Network = self
	Objects.VALID_CSV_DATA = false
	Objects.run.connect(is_running)
	Objects.train.connect(train_backpropagation)
	Objects.test.connect(test)
	Objects.csv_selected.connect(load_csv)
	Objects.weights_randomized.connect(randomize_weights)
	Objects.weights_zeroed.connect(zero_weights)
	# csetup()
	#setup(13,4)
	#set_perceptrons_per_layer([8,2,3,5])
	pass

func csetup():
	add_input_layer()
	for i in range(perceptron_layer_count):
		add_layer(perc_per_layer[i])
	queue_redraw()
	goutput_count = perc_per_layer[-1]
	add_output_layer()
	#Objects.perceptron_pressed.connect(show_connections)
	#Objects.simulate_running.connect(simulate)

func _draw():
	if selected_x != null and selected_y != null:
		draw_specific()
	else:
		draw_connections()


func add_input_layer():
	var layer = base_perceptron_layer.instantiate()
	layer.input_count = ginput_count
	add_child(layer)
	glayers.append(layer)

func add_output_layer():
	var layer = base_perceptron_layer.instantiate()
	layer.output_count = goutput_count
	add_child(layer)
	glayers.append(layer)


func add_layer(value=1):
	var layer = base_perceptron_layer.instantiate()
	layer.children_count = value
	layer.start_index = perceptron_count
	perceptron_count += value
	glayers.append(layer)
	add_child(layer)
	perceptron_layer_count += 1

func remove_layer():
	glayers.pop_back().queue_free()
	perceptron_layer_count -= 1

# do a thingie, where it will go through every valid perceptron add show connections, like it's running
func simulate(test_data):
	test(test_data,true)

func show_connections(pos_x, pos_y):
	selected_x = pos_x
	selected_y = pos_y
	queue_redraw()

func draw_specific():
	draw_connections()
	if forward_dir:
		for sibling_i in range(layers[selected_x - 1].child_count()):
			var pos_p = Vector2(start_left + offset_x + diff_x * (selected_x - 1), start_top + diff_y * sibling_i)
			var pos_s = Vector2(start_left - offset_x + diff_x * selected_x, start_top + diff_y * selected_y)
			draw_line(pos_p, pos_s, Color(255.0/255.0, 0/255.0, 0/255.0, 1), 3)
	else:
		if selected_x == layers.size() - 2:
			var pos_p = Vector2(start_left + diff_x * selected_x, start_top + diff_y * selected_y)
			var pos_s = Vector2(start_left + diff_x * (selected_x + 1), start_top + diff_y * selected_y)
			draw_line(pos_p, pos_s, Color(255.0/255.0, 0/255.0, 0/255.0, 1), 3)
			return
		for sibling_i in range(layers[selected_x + 1].child_count()):
			var pos_p = Vector2(start_left + offset_x + diff_x * selected_x, start_top + diff_y * selected_y)
			var pos_s = Vector2(start_left - offset_x + diff_x *(selected_x + 1), start_top + diff_y * sibling_i)
			draw_line(pos_p, pos_s, Color(255.0/255.0, 0/255.0, 0/255.0, 1), 3)


func draw_connections():
	for layer_i in layers.size() - 2:
		for perceptron_i in layers[layer_i].child_count():
			for sibling_i in layers[layer_i].right_layer.child_count():
				var pos_p = Vector2(start_left + offset_x + diff_x * layer_i, start_top + diff_y * perceptron_i)
				var pos_s = Vector2(start_left -offset_x + diff_x * (layer_i + 1), start_top + diff_y * sibling_i)
				draw_line(pos_p, pos_s, Color(194/255.0, 195/255.0, 197/255.0, 0.3), 2)
	for perceptron_i in output_layer.child_count():
		var pos_p = Vector2(start_left + diff_x * (output_layer.pos_x - 1), start_top + diff_y * perceptron_i)
		var pos_s = Vector2(start_left + diff_x * output_layer.pos_x, start_top + diff_y * perceptron_i)
		draw_line(pos_p, pos_s, Color(194/255.0, 195/255.0, 197/255.0, 0.3), 2)

	


# NEURAL NETWORK IMPLEMENTATION

var step_bipolar_threshold = 0
var identity_a = 1
var parametric_a = 0.1
var layer_count = 0
var layers = []
var perc_layers = []
var input_layer = null
var output_layer = null
var perceptrons_per_layer = []
var input_count = 0
var output_count = 0
var training_data = []
var training_outputs = []
var moving_i = 1


func init(i_learning_rate=0.1, i_momentum = 0, i_step_bipolar_threshold = 0, i_identity_a = 1, i_parametric_a = 0.1):
	Objects.learning_rate = i_learning_rate
	Objects.momentum = i_momentum
	step_bipolar_threshold = i_step_bipolar_threshold
	identity_a = i_identity_a
	parametric_a = i_parametric_a

func get_perceptron_count():
	return Objects.sum(perceptrons_per_layer)

func get_input_values():
	var res = []
	for item in input_layer.children:
		res.append(item.output)
	return res

func set_input_values(i_values):
	for i in input_layer.child_count():
		input_layer.children[i].output = i_values[i]

func get_output_values():
	var res = []
	for i in output_layer.child_count():
		res.append(output_layer.children[i].output)

func randomize_weights(around_ten=false):
	clear_all()
	for i in perc_layers.size():
		perc_layers[i].randomize_weights(around_ten)

func set_children_weights(index, weights):
	perc_layers[index].set_children_weights(weights)

func load_csv(i_path):
	print("CSV SELECTED: "+ str(i_path))
	var test = Objects.Base_InfoPopup.instantiate()
	add_child(test)
	var data = []
	var output = []
	var dirty = load(i_path)
	var values = []
	for i in dirty.records.size():
		values.append([])
		for j in dirty.records[i].size():
			values[i].append(float(dirty.records[i][j]))
	for i in values.size():
		output.append([])
		for j in output_layer.child_count():
			output[i].append(values[i].pop_back())
		output[i].reverse()
	data = values
	if data[0].size() != input_layer.children.size() or output[0].size() != output_layer.children.size():
		test.set_error("MISMATCH BETWEEN INPUT AND OUPUT COUNT FOR DATA")
		print("size mismatch")
		return
	test.set_success("TRAINING DATA LOADED CORRECTLY. " + str(data.size()) + " ROWS")
	# GETY RID OF DATA WITH TRAILING EMPTY LENGTH
	Objects.VALID_CSV_DATA = true
	training_data = data
	training_outputs = output
	#return [data, output]
		

func test(i_inputs, i_verbose=false):
	#i_inputs = [1,1]
	is_running(true)
	forward(i_inputs)
	var results = []
	for item in output_layer.children:
		results.append(item.output)
	if i_verbose:
		print('Input ',i_inputs," | Output ", results)
	else:
		print(results)

#func learning_rate_decay(decay_factor):
#	learning_rate -= snappedf(learning_rate * decay_factor, 0.0001)

#func learning_rate_linear_reduction(original, min = 0.0001, steps=100):
#	var reduction = (original - min) / steps
#	learning_rate -= reduction

func forward(single_data):
	set_input_values(single_data)
	for i in perc_layers.size():
		perc_layers[i].calc_outputs()
	perc_layers[-1].forward_output()

func propagate_error(single_output):
	var total_error = 0
	#single_output.reverse()
	total_error += perc_layers[-1].calc_errors(single_output)
	for i in range(perc_layers.size() - 2, -1, -1):
		total_error += perc_layers[i].calc_errors()
	return total_error

func update_weights():
	for i in perc_layers.size():
		perc_layers[i].update_children_weights()

func get_perc_layers():
	return perc_layers


func set_perceptrons_per_layer(i_perceptrons_per_layer):
	for i in perc_layers.size():
		for j in i_perceptrons_per_layer[i]:
			var obj = Objects.Base_Perceptron.instantiate()
			obj.init(Objects.ActivationFunctions.STEP_UNIPOLAR)
			obj.index = moving_i
			moving_i += 1
			perc_layers[i].cadd_child(obj)
	for i in perc_layers[-1].children.size():
		var obj = Objects.Base_InputOutput.instantiate()
		obj.index = moving_i
		obj.pos_x = output_layer.pos_x
		obj.pos_y = output_layer.child_count()
		moving_i += 1
		output_layer.cadd_child(obj)
	queue_redraw()
	Objects.perceptron_pressed.connect(show_connections)
	#set_children_weights(0,[[0.897, -0.27, -0.317], [0.174, 0.086, 0.291]])
	#set_children_weights(1,[[0.988, 0.058, 0.16]])

func prepare_for_backpropagation():
	for i in perc_layers.size():
		perc_layers[i].prepare_for_backpropagation()

func set_layer_activation_function(i_id, i_activation_function):
	perc_layers[i_id].set_children_functions(i_activation_function)

func set_activation_functions(i_activation_functions):
	for i in perc_layers.size():
		perc_layers[i].set_children_functions(i_activation_functions[i])

func setup(i_inputs = 1, i_perc_layers = 1):
	var moving_pos = 0
	var layer = Objects.Base_Layer.instantiate()
	layer.pos_x = moving_pos
	moving_pos += 1
	layers.append(layer)
	add_child(layer)
	for i in i_perc_layers:
		layer = Objects.Base_Layer.instantiate()
		layer.pos_x = moving_pos
		moving_pos += 1
		layers.append(layer)
		perc_layers.append(layer)
		add_child(layer)
	
	layer = Objects.Base_Layer.instantiate()
	layer.pos_x = moving_pos
	moving_pos += 1
	layers.append(layer)
	add_child(layer)
	input_layer = layers[0]
	output_layer = layers[-1]
	for i in i_inputs:
		var input = Objects.Base_InputOutput.instantiate()
		input.pos_x = 0
		input.pos_y = layers[0].child_count()
		input.index = moving_i
		moving_i += 1
		layers[0].cadd_child(input)
	for i in layers.size():
		if i == 0:
			layers[i].right_layer = layers[i + 1]
		if i == layers.size() - 1:
			layers[i].left_layer = layers[i - 1]
		else:
			layers[i].left_layer = layers[i - 1]
			layers[i].right_layer = layers[i + 1]

func is_running(run):
	for i in layers.size():
		layers[i].is_running(run)

func zero_weights():
	clear_all()
	for i in perc_layers.size():
		perc_layers[i].zero_weights()


func clear_all():
	for layer in layers:
		layer.clear_all()

func train_backpropagation(
	error_threshold=0.00001,
	decay_learning_rate=false,
	decay_factor=0.1,
	epoch_decay_step=10,
	linear_reduction_learning_rate=false,
	linear_min=0.0001,
	linear_steps=100):
	is_running(true)
	var test = Objects.Base_InfoPopup.instantiate()
	add_child(test)
	test.empty()
	var original_learning_rate = Objects.learning_rate
	prepare_for_backpropagation()
	var iter_count = 0
	var indexes = []
	var data_to_train = []
	var outputs_to_train = []
	var error = 0
	var total_error = 0
	var average_error = 0
	for i in training_data.size():
		indexes.append(i)
	while iter_count < Objects.limit_iter:
		iter_count += 1
		total_error = 0
		randomize()
		indexes.shuffle()
		for index in indexes:
			data_to_train.append(training_data[index])
			outputs_to_train.append(training_outputs[index])
		for i in data_to_train.size():
			forward(data_to_train[i])
			error = propagate_error(outputs_to_train[i])
			total_error += error * error
			update_weights()
		average_error = total_error / data_to_train.size()
		if average_error < Objects.error_threshold:
			break
		if iter_count % int(Objects.limit_iter / 100) == 0:
			if test != null:
				test.progress()
				test.avg_error(average_error)
				await get_tree().create_timer(0.0001).timeout
			else:
				break
	if test != null:
		test.avg_error(average_error)
		test.set_success("TRAINING FINISHED")


