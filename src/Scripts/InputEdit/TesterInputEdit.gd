extends HBoxContainer
@onready var numlineedit = get_node("LineEdit")
@onready var LineEditRegEx = RegEx.new()
@onready var pos_label = get_node("Label")
var old_text = ""
var pos = 0
var test_value: float :
	get:
		return float(old_text)

# Called when the node enters the scene tree for the first time.
func _ready():
	LineEditRegEx.compile("^[0-9.]*$")
	pos_label.text = "input %-*d:" % [ 7 -str(pos).length(),pos]


func _on_line_edit_text_changed(new_text):
	if LineEditRegEx.search(new_text):
		old_text = str(new_text)
	else:
		numlineedit.text = old_text
		numlineedit.caret_column = old_text.length()
