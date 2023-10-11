extends RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready():
	var isWeightDisplayed = get_node('../..').display_weight
	var weight = get_node('../..').weight


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
