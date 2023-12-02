extends PopupPanel

var base_text = "[center][font_size={20}]%s[/font_size][/center]"
@onready var success_node = get_node("Control/SUCCESS_TEXT")
@onready var error_node = get_node("Control/ERROR_TEXT")
@onready var progress_bar = get_node("Control/ProgressBar")
@onready var training_error = get_node("Control/TRAINING_ERROR")
var value = 0

func _ready():
	pass # Replace with function body.

func empty():
	error_node.text = ""
	success_node.text = ""

func avg_error(error):
	training_error.visible = true
	training_error.text = "Average Error: %.4f" % error

func progress():
	progress_bar.visible = true
	value += 1
	progress_bar.value = value

func set_error(text):
	success_node.text = ""
	error_node.text = base_text % text

func set_success(text):
	error_node.text = ""
	success_node.text = base_text % text

func _on_close_requested():
	hide()
	queue_free()
