extends HBoxContainer
var base_perceptron_layer = load("res://src/Scenes/Layer.tscn")
var perceptron_layer_count: int = 0
var perc_per_layer: Array = []
var perceptron_count: int= 1 
@onready var MainScene = get_tree().root.get_child(0)
var layers: Array = []
var start_left: int = 250
var start_top = 100
var diff_x = 200
var diff_y = 120

# Called when the node enters the scene tree for the first time.
func _ready():
	setup()

func setup():
	for i in range(perceptron_layer_count):
		add_layer(perc_per_layer[i])
	queue_redraw()

func _draw():
		draw_connections()
		#var start = Vector2(250,100)
		#draw_line(start, Vector2(450,100 + 120 * i), Color(1,1,1), 5)
		# draw_line(start, Vector2(450,250), Color(1,1,1), 5)


func add_layer(value=1):
	var layer = base_perceptron_layer.instantiate()
	layer.children_count = value
	layer.start_index = perceptron_count
	perceptron_count += value
	layers.append(layer)
	add_child(layer)
	perceptron_layer_count += 1

func remove_layer():
	get_children()[get_child_count() - 1].queue_free()
	perceptron_layer_count -= 1

func draw_connections():
	var ConnectionTable = []
	for layer_i in range(layers.size() - 1):
		for perceptron_i in range(layers[layer_i].perceptrons.size()):
			for sibling_i in range(layers[layer_i + 1].perceptrons.size()):
				var pos_p = Vector2(start_left + 200 * layer_i, start_top + 120 * perceptron_i)
				var pos_s = Vector2(start_left + 210 * (layer_i + 1), start_top + 120 * sibling_i)
				draw_line(pos_p, pos_s, Color(194/255.0, 195/255.0, 197/255.0), 2)
	
