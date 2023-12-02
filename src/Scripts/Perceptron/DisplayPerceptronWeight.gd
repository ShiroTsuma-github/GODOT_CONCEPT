extends RichTextLabel

@onready var parent = get_node('../..')
var to_format = "[center][font_size={14}]%.3f[/font_size][/center]"

# Called when the node enters the scene tree for the first time.
func _ready():
	#parent.update_visual_data.connect(update_data)
	#update_data()
	pass

func update_data():
	var isWeightDisplayed = parent.display_weight
	#var weight = parent.weights[0]
	var weight = parent.calc_sum()
	text =  to_format % [weight]

