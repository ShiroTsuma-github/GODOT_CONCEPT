extends RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready():
	var isWeightDisplayed = get_node('../..').display_weight
	var weight = get_node('../..').weight
	var to_format = "[center][font_size={14}]%.3f[/font_size][/center]"
	visible = isWeightDisplayed
	text =  to_format % [weight]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
