extends TextureRect


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_guzik_nowy_pressed():
	Objects.Base_Start_Window_NEW = true
	Objects.Base_Start_Window_BLOCK_CLOSE = true
	var start_window = Objects.Base_Start_Window.instantiate()
	start_window.setup_network.connect(get_tree().get_root().get_node("MainScene").forward_signal)
	add_child(start_window)



func _on_guzik_load_pressed():
	var filedialog = load("res://src/Scenes/FileDialog.tscn")
	var test = filedialog.instantiate()
	test.add_filter("*.nn")
	add_child(test)
