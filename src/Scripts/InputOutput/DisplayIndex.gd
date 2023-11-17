extends RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready():
	var isWeightDisplayed = get_node('../..').display_weight
	var weight = get_node('../..').weight

