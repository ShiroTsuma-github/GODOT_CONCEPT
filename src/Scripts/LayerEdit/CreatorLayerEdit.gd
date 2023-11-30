extends HBoxContainer
@export var perceptron_count: int = 1
@export var layer_function = Objects.ActivationFunctions.STEP_UNIPOLAR

@onready var dropdown = get_node("PercActivFunc")


# Called when the node enters the scene tree for the first time.
func _ready():
	add_perc_funcs()
	#dropdown.remove_item(0)


func _on_spin_box_value_changed(value):
	perceptron_count = value

func add_perc_funcs():
	dropdown.add_item("Step Bipolar")
	dropdown.add_separator()
	dropdown.add_item("Simgoid Unipolar")
	dropdown.add_item("Sigmoid Bipolar")
	dropdown.add_separator()
	dropdown.add_item("Identity")
	dropdown.add_separator()
	dropdown.add_item("RELU")
	dropdown.add_item("RELU LEAKY")
	dropdown.add_item("RELU PARAMETRIC")
	dropdown.add_separator()
	dropdown.add_item("Softplus")
	


func _on_perc_activ_func_item_selected(index):
	match index:
		0:
			layer_function = Objects.ActivationFunctions.STEP_UNIPOLAR
		1:
			layer_function = Objects.ActivationFunctions.STEP_BIPOLAR
		3:
			layer_function = Objects.ActivationFunctions.SIGMOID_UNIPOLAR
		4:
			layer_function = Objects.ActivationFunctions.SIGMOID_BIPOLAR
		6:
			layer_function = Objects.ActivationFunctions.IDENTITY
		8:
			layer_function = Objects.ActivationFunctions.RELU
		9:
			layer_function = Objects.ActivationFunctions.RELU_LEAKY
		10:
			layer_function = Objects.ActivationFunctions.RELU_PARAMETRIC
		12:
			layer_function = Objects.ActivationFunctions.SOFTPLUS
		_:
			assert(1==2, "No matching function")
