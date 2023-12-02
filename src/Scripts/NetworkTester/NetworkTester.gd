extends PopupPanel
@onready var container = get_node("Control/MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer")

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in Objects.Network.input_layer.child_count():
		var single_line = Objects.Base_TesterInputEdit.instantiate()
		single_line.pos = i + 1
		container.add_child(single_line)





func _on_b_test_pressed():
	var test_values = []
	for item in container.get_children():
		test_values.append(item.test_value)
	Objects.test.emit(test_values)
	hide()
	queue_free()
