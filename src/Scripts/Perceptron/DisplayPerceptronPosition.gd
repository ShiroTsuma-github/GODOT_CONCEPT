extends RichTextLabel
var to_format = "[center][font_size={40}]w[/font_size][font_size={12}]%d,%d[/font_size][/center]"
@onready var parent = get_node('../..')


# Called when the node enters the scene tree for the first time.
func _ready():
	parent.update_visual_data.connect(update_data)
	var layer = parent.layer
	var layer_pos = parent.layer_pos
	text =  to_format % [layer,layer_pos]



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func update_data():
	var layer = parent.layer
	var layer_pos = parent.layer_pos
	text =  to_format % [layer,layer_pos]
