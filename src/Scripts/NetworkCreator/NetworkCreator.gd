extends PopupPanel

@onready var layer_edit_container = get_node("MarginContainer/VBoxContainer/Control/ScrollContainer/VBoxContainer")
@onready var button = get_node("MarginContainer/VBoxContainer/HBoxContainer/Button")

var base_layer_edit = load("res://src/Scenes/CreatorLayerEdit.tscn")
var filedialog = load("res://src/Scenes/FileDialog.tscn")


func _ready():
	button.create_layer_setup.connect(setup_layer_config)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

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
		new_layer_edit.get_child(0).text = "Layer %-*d" % [ 7 -str(index + i).length(),(index + i)]
		layer_edit_container.add_child(new_layer_edit)

func remove_layer_config(value):
	var children = layer_edit_container.get_children()
	children.reverse()
	print(value)
	for i in range(value):
		children[i].queue_free()
	



func _on_open_file_dialog_pressed():
	var test = filedialog.instantiate()
	add_child(test)


func _on_create_network_pressed():
	get_node("MarginContainer/VBoxContainer2").visible = false
	get_node("MarginContainer/VBoxContainer").visible = true
