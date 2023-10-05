extends Sprite2D

@export var center: bool = true
@export var layer: int = 0
@export var layer_pos: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	if center:
		self.position = get_viewport_rect().size / 2
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
