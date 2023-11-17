extends HBoxContainer
@export var perceptron_count: int = 1

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
	
