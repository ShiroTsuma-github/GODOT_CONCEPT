extends RichTextLabel
var to_format = "[center][font_size={40}]P[/font_size][font_size={12}]%d[/font_size][/center]"
@onready var parent = get_node('../..')


# Called when the node enters the scene tree for the first time.
func _ready():
	parent.update_visual_data.connect(update_data)
	update_data()





func update_data():
	#var position_index = parent.position_index
	#var weight_index = parent.weight_index
	text =  to_format % [parent.index]
