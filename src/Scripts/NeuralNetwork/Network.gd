extends HBoxContainer
var base_perceptron_layer = load("res://src/Scenes/Layer.tscn")
var perceptron_layer_count: int = 0
var perc_per_layer: Array = []
var perceptron_count: int = 1 
var input_count: int = 1
var output_count: int = 1
@onready var MainScene = get_tree().root.get_child(0)
var layers: Array = []
var start_left: int = 110
var start_top = 100
var diff_x = 160
var diff_y = 130
var offset_x = 40
var selected_x = null
var selected_y = null

# Called when the node enters the scene tree for the first time.
func _ready():
	setup()

func setup():
	add_input_layer()
	for i in range(perceptron_layer_count):
		add_layer(perc_per_layer[i])
	queue_redraw()
	output_count = perc_per_layer[-1]
	add_output_layer()
	Objects.perceptron_pressed.connect(show_connections)
	Objects.simulate_running.connect(simulate)

func _draw():
	print("in draw", selected_x, selected_y)
	if selected_x != null and selected_y != null:
		draw_specific()
	else:
		draw_connections()


func add_input_layer():
	var layer = base_perceptron_layer.instantiate()
	layer.input_count = input_count
	add_child(layer)
	layers.append(layer)

func add_output_layer():
	var layer = base_perceptron_layer.instantiate()
	layer.output_count = output_count
	add_child(layer)
	layers.append(layer)


func add_layer(value=1):
	var layer = base_perceptron_layer.instantiate()
	layer.children_count = value
	layer.start_index = perceptron_count
	perceptron_count += value
	layers.append(layer)
	add_child(layer)
	perceptron_layer_count += 1

func remove_layer():
	layers.pop_back().queue_free()
	perceptron_layer_count -= 1

# do a thingie, where it will go through every valid perceptron add show connections, like it's running
func simulate():
	var max_x = layers.size() - 1
	var current_x = 0
	var current_max_y = layers[current_x]
	for layer_i in range(layers.size()):
		for child_i in range(layers[layer_i].perceptrons.size()):
			if layer_i == 0 or layer_i == layers.size() - 1:
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
	for line in layers:
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
	for sibling_i in range(layers[selected_x - 1].perceptrons.size()):
		var pos_p = Vector2(start_left + offset_x + diff_x * (selected_x - 1), start_top + diff_y * sibling_i)
		var pos_s = Vector2(start_left - offset_x + diff_x * selected_x, start_top + diff_y * selected_y)
		draw_line(pos_p, pos_s, Color(255.0/255.0, 0/255.0, 0/255.0, 1), 3)


func draw_connections():
	print('drawing')
	var ConnectionTable = []
	for layer_i in range(layers.size() - 2):
		for perceptron_i in range(layers[layer_i].perceptrons.size()):
			for sibling_i in range(layers[layer_i + 1].perceptrons.size()):
				var pos_p = Vector2(start_left + offset_x + diff_x * layer_i, start_top + diff_y * perceptron_i)
				var pos_s = Vector2(start_left -offset_x + diff_x * (layer_i + 1), start_top + diff_y * sibling_i)
				draw_line(pos_p, pos_s, Color(194/255.0, 195/255.0, 197/255.0, 0.3), 2)
	var last_layer = layers.size() - 1
	for perceptron_i in range(layers[-1].perceptrons.size()):
		var pos_p = Vector2(start_left + diff_x * (last_layer - 1), start_top + diff_y * perceptron_i)
		var pos_s = Vector2(start_left + diff_x * last_layer, start_top + diff_y * perceptron_i)
		draw_line(pos_p, pos_s, Color(194/255.0, 195/255.0, 197/255.0, 0.3), 2)
	
