extends RichTextLabel



# Called when the node enters the scene tree for the first time.
func _ready():
	var to_format = "[center][font_size={80}]w[/font_size][font_size={25}]%d,%d[/font_size][/center]"
	var layer = get_node('../..').layer
	var layer_pos = get_node('../..').layer_pos
	text =  to_format % [layer,layer_pos]
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
