extends RichTextLabel

var to_format = "[center][font_size={40}]U[/font_size][font_size={12}]%d[/font_size][/center]"

# Called when the node enters the scene tree for the first time.
func _ready():
	var obj = get_parent().get_parent()
	text = to_format % obj.index

