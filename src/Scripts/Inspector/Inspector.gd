extends Control
var object = null

@onready var function_label = get_node("InspectorRight/MarginContainer/VBoxContainer/VBoxContainer2/LActivation")
@onready var weight_container = get_node("InspectorRight/MarginContainer/VBoxContainer/HBoxContainer2/VBoxContainer")
@onready var output_container = get_node("InspectorRight/MarginContainer2/VBoxContainer/VBoxContainer/Control/ScrollContainer/VBoxContainer")
@onready var perc_inspector = get_node("InspectorRight/MarginContainer")
@onready var inout_inspector = get_node('InspectorRight/MarginContainer2')
# Called when the node enters the scene tree for the first time.
func _ready():
	if object.name == 'Perceptron':
		perc_inspector.visible = true
		inout_inspector.visible = false
		function_label.text = activation_to_name(object.activation_function)
		var label = Label.new()
		for i in object.weights.size():
			label = Label.new()
			label.horizontal_alignment = 0
			label.text = str(i) + ": " + str(object.weights[i])
			output_container.add_child(label)
	else:
		perc_inspector.visible = false
		inout_inspector.visible = true
		var out_label = Label.new()
		for i in object.previous_outputs.size():
			out_label = Label.new()
			out_label.text = str(i) + ": " + str(object.previous_outputs[i])
			output_container.add_child(out_label)
			
			
	#weight_label.text = str(object.weights)


func activation_to_name(value):
	match value:
		0:
			return "STEP UNIPOLAR"
		1:
			return "STEP BIPOLAR"
		2:
			return "SIGMOID UNIPOLAR"
		3:
			return "SIGMOID BIPOLAR"
		4:
			return "IDENTITY"
		5:
			return "RELU"
		6:
			return "RELU LEAKY"
		7:
			return "RELU PARAMETRIC"
		8:
			return "SOFTPLUS"
		_:
			return "WE ARE FUCKED"
			
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	hide()
	queue_free()
