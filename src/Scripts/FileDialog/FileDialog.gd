extends FileDialog


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_file_selected(path):
	if path.ends_with(".csv"):
		Objects.csv_selected.emit(path)
	elif path.ends_with(".nn"):
		Objects.netork_selected.emit(path)
	queue_free()
