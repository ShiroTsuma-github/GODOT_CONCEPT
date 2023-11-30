extends Window

@onready var layer_edit_container = get_node("MarginContainer/Creator/Control/ScrollContainer/VBoxContainer")
@onready var button = get_node("MarginContainer/Creator/InputSetupContainer/LayerSetupContainer/Button")
@onready var input_count = get_node("MarginContainer/Creator/InputSetupContainer/SpinBox2")

var base_layer_edit = load("res://src/Scenes/CreatorLayerEdit.tscn")
var filedialog = load("res://src/Scenes/FileDialog.tscn")
var layer_count: int = 1
var input_count_value: int = 1
var percpetrons_per_layer: Array = []
var layer_functions = []
signal setup_network(layers, perceptrons, inputs, functions)

func _ready():
	get_node("MarginContainer/NewLoad").visible = true
	get_node("MarginContainer/Creator").visible = false
	if Objects.Base_Start_Window_NEW == true:
		_on_create_network_pressed()
		Objects.Base_Start_Window_NEW = false
	if Objects.Base_Start_Window_LOAD == true:
		_on_open_file_dialog_pressed()
		Objects.Base_Start_Window_LOAD = false
	button.create_layer_setup.connect(setup_layer_config)
	add_layer_config(1)


func setup_layer_config():
	var spinbox_value = int(button.layer_count)
	var diff = spinbox_value - layer_edit_container.get_child_count()
	if diff == 0:
		return
	elif diff < 0:
		diff = -diff
		remove_layer_config(diff)
		return
	add_layer_config(diff)


func add_layer_config(value):
	var index = layer_edit_container.get_child_count() + 1
	for i in range(value):
		var new_layer_edit = base_layer_edit.instantiate()
		new_layer_edit.get_child(0).text = "Perceptrons L. %-*d" % [ 6 -str(index + i).length(),(index + i)]
		layer_edit_container.add_child(new_layer_edit)


func remove_layer_config(value):
	var children = layer_edit_container.get_children()
	children.reverse()
	for i in range(value):
		children[i].queue_free()
	

func _on_open_file_dialog_pressed():
	var test = filedialog.instantiate()
	test.add_filter("*.nn")
	add_child(test)


func _on_create_network_pressed():
	get_node("MarginContainer/NewLoad").visible = false
	get_node("MarginContainer/Creator").visible = true


func _on_close_requested():
	hide()
	if Objects.Base_Start_Window_BLOCK_CLOSE == true:
		Objects.Base_Start_Window_BLOCK_CLOSE = false
		return
	get_tree().quit()


func get_network_config():
	layer_count = layer_edit_container.get_child_count()
	input_count_value = input_count.value
	for item in layer_edit_container.get_children():
		percpetrons_per_layer.append(item.perceptron_count)
		layer_functions.append(item.layer_function)


func _on_accept_close_button_pressed():
	get_network_config()
	setup_network.emit(layer_count, percpetrons_per_layer, input_count_value, layer_functions)
	hide()


func _on_open_examples_pressed():
	var test = filedialog.instantiate()
	test.add_filter("*.nn")
	
	

	add_child(test)



func _on_show_author_pressed():
	pass # Replace with function body.
