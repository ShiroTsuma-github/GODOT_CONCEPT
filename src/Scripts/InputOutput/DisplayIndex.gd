extends RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready():
	var isOutputDisplayed = get_node('../..').display
	var output = get_node('../..').output

