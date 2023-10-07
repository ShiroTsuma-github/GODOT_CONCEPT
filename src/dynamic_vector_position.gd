extends RichTextLabel



# Called when the node enters the scene tree for the first time.
func _ready():
	var to_format = "[center][font_size={80}]w[/font_size][font_size={25}]%d,%d[/font_size][/center]"
	var position_index = get_node('../..').position_index
	var position_index_pos = get_node('../..').position_index_pos
	text =  to_format % [position_index,position_index_pos]
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
