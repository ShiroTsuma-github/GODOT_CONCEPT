extends RichTextLabel

@onready var parent = get_node('../..')
var to_format = "[center][font_size={14}]%.3f[/font_size][/center]"

# Called when the node enters the scene tree for the first time.
func _ready():
	parent.update_visual_data.connect(update_data)
	update_data()

func update_data():
	var isWeightDisplayed = parent.display_weight
	var weight = parent.weights[0]
	text =  to_format % [weight]

