extends HBoxContainer
var base_perceptron_layer = load("res://src/Scenes/Layer.tscn")
var perceptron_layer_count: int = 0
var perc_per_layer: Array = []
var perceptron_count: int = 1 
var ginput_count: int = 1
var goutput_count: int = 1
@onready var MainScene = get_tree().root.get_child(0)
var glayers: Array = []
var start_left: int = 110
var start_top = 100
var diff_x = 160
var diff_y = 130
var offset_x = 40
var selected_x = null
var selected_y = null
var forward_dir = true

# Called when the node enters the scene tree for the first time.
func _ready():
	setup()

func setup():
	add_input_layer()
	for i in range(perceptron_layer_count):
		add_layer(perc_per_layer[i])
	queue_redraw()
	goutput_count = perc_per_layer[-1]
	add_output_layer()
	Objects.perceptron_pressed.connect(show_connections)
	Objects.simulate_running.connect(simulate)

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
func simulate():
	var max_x = glayers.size() - 1
	var current_x = 0
	var current_max_y = glayers[current_x]
	for layer_i in range(glayers.size()):
		for child_i in range(glayers[layer_i].perceptrons.size()):
			if layer_i == 0 or layer_i == glayers.size() - 1:
				continue
			selected_x = layer_i
			selected_y = child_i
			queue_redraw()

func show_connections(perceptron):
	var item_x = 0
	var item_y = 0
	var found = false
	var x = -1
	var y = -1
	for line in glayers:
		if found:
			break
		x += 1
		y = -1
		for child in line.get_children()[0].get_children():
			if found:
				break
			y += 1
			if perceptron == child:
				item_x = x
				item_y = y
				found = true
	selected_x = x
	selected_y = y
	queue_redraw()

func draw_specific():
	draw_connections()
	if forward_dir:
		for sibling_i in range(glayers[selected_x - 1].perceptrons.size()):
			var pos_p = Vector2(start_left + offset_x + diff_x * (selected_x - 1), start_top + diff_y * sibling_i)
			var pos_s = Vector2(start_left - offset_x + diff_x * selected_x, start_top + diff_y * selected_y)
			draw_line(pos_p, pos_s, Color(255.0/255.0, 0/255.0, 0/255.0, 1), 3)
	else:
		if selected_x == glayers.size() - 2:
			var pos_p = Vector2(start_left + diff_x * selected_x, start_top + diff_y * selected_y)
			var pos_s = Vector2(start_left + diff_x * (selected_x + 1), start_top + diff_y * selected_y)
			draw_line(pos_p, pos_s, Color(255.0/255.0, 0/255.0, 0/255.0, 1), 3)
			return
		for sibling_i in range(glayers[selected_x + 1].perceptrons.size()):
			var pos_p = Vector2(start_left + offset_x + diff_x * selected_x, start_top + diff_y * selected_y)
			var pos_s = Vector2(start_left - offset_x + diff_x *(selected_x + 1), start_top + diff_y * sibling_i)
			draw_line(pos_p, pos_s, Color(255.0/255.0, 0/255.0, 0/255.0, 1), 3)


func draw_connections():
	var ConnectionTable = []
	for layer_i in range(glayers.size() - 2):
		for perceptron_i in range(glayers[layer_i].perceptrons.size()):
			for sibling_i in range(glayers[layer_i + 1].perceptrons.size()):
				var pos_p = Vector2(start_left + offset_x + diff_x * layer_i, start_top + diff_y * perceptron_i)
				var pos_s = Vector2(start_left -offset_x + diff_x * (layer_i + 1), start_top + diff_y * sibling_i)
				draw_line(pos_p, pos_s, Color(194/255.0, 195/255.0, 197/255.0, 0.3), 2)
	var last_layer = glayers.size() - 1
	for perceptron_i in range(glayers[-1].perceptrons.size()):
		var pos_p = Vector2(start_left + diff_x * (last_layer - 1), start_top + diff_y * perceptron_i)
		var pos_s = Vector2(start_left + diff_x * last_layer, start_top + diff_y * perceptron_i)
		draw_line(pos_p, pos_s, Color(194/255.0, 195/255.0, 197/255.0, 0.3), 2)
	


# NEURAL NETWORK IMPLEMENTATION

var learning_rate = 0.1
var momentum = 0
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


func init(i_learning_rate=0.1, i_momentum = 0, i_step_bipolar_threshold = 0, i_identity_a = 1, i_parametric_a = 0.1):
	learning_rate = i_learning_rate
	momentum = i_momentum
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
	for i in perc_layers.size():
		perc_layers[i].randomize_weights(around_ten)

func load_csv(i_path):
	var data = []
	var output = []
	var dirty = load(i_path)
	var values = []
	for i in dirty.records.size():
		values.append([])
		for j in dirty.records[i].size():
			values[i].append(float(dirty.records[i][j]))
	for i in values.size():
		for j in input_count:
			output.append(values[i].pop_back())
	data = values
	return [data, output]
		

func test(i_inputs, i_verbose):
	forward(i_inputs)
	var results = []
	for item in output_layer.children:
		results.append(item.output)
	if i_verbose:
		print('Input ',i_inputs," | Output ", results)
	else:
		print(results)

func learning_rate_decay(decay_factor):
	learning_rate -= snappedf(learning_rate * decay_factor, 0.0001)

func learning_rate_linear_reduction(original, min = 0.0001, steps=100):
	var reduction = (original - min) / steps
	learning_rate -= reduction

func forward(single_data):
	set_input_values(single_data)
	for i in perc_layers.size():
		perc_layers[i].calc_outputs()
	perc_layers[-1].forward_output()

func propagate_error(single_output):
	var total_error = 0
	total_error += perc_layers[-1].calc_errors(single_output)
	for i in range(perc_layers.size() - 2, -1, -1):
		total_error += perc_layers[i].calc_errors()
	return total_error

func update_weights():
	for i in perc_layers.size():
		perc_layers[i].update_children_weights()

func get_perc_layers():
	return perc_layers
