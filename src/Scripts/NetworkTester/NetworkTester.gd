extends PopupPanel
@onready var container = get_node("Control/MarginContainer/ScrollContainer/VBoxContainer")

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in Objects.Network.input_layer.child_count():
		var single_line = Objects.Base_TesterInputEdit.instantiate()
		container.add_child(single_line)



