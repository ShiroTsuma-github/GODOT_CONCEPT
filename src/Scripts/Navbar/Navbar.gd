extends TextureRect

@onready var momentum_slider = get_node("MarginContainer2/HBoxContainer/VBoxContainer9/HBoxContainer2/SMomentum")
@onready var learning_slider = get_node("MarginContainer2/HBoxContainer/VBoxContainer9/HBoxContainer/SlearningRate")
@onready var momentum_label = get_node("MarginContainer2/HBoxContainer/VBoxContainer9/HBoxContainer2/Label")
@onready var learning_label = get_node("MarginContainer2/HBoxContainer/VBoxContainer9/HBoxContainer/Label")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.




func _on_guzik_nowy_pressed():
	Objects.Base_Start_Window_NEW = true
	Objects.Base_Start_Window_BLOCK_CLOSE = true
	var start_window = Objects.Base_Start_Window.instantiate()
	start_window.setup_network.connect(get_tree().get_root().get_node("MainScene").forward_signal)
	add_child(start_window)



func _on_guzik_load_pressed():
	var test = Objects.Base_FileDialog.instantiate()
	test.add_filter("*.nn")
	add_child(test)


func _on_button_2_pressed():
	var test = Objects.Base_FileDialog.instantiate()
	test.set_current_path(ProjectSettings.globalize_path("res://Data/"))
	test.add_filter("*.csv")
	add_child(test)



func _on_b_zero_pressed():
	Objects.run.emit(true)
	Objects.weights_zeroed.emit()
	var test = Objects.Base_InfoPopup.instantiate()
	add_child(test)
	test.set_success("WEIGHTS CLEARED")


func _on_b_randomize_pressed():
	Objects.run.emit(true)
	Objects.weights_randomized.emit()
	var test = Objects.Base_InfoPopup.instantiate()
	add_child(test)
	test.set_success("WEIGHTS RANDOMIZED")


func _on_b_test_pressed():
	var tester = Objects.Base_NetworkTester.instantiate()
	add_child(tester)


func _on_b_train_pressed():
	if Objects.VALID_CSV_DATA:
		var test = Objects.Base_InfoPopup.instantiate()
		add_child(test)
		test.set_success("INITIALIZED TRAINING")
		await get_tree().create_timer(1.0).timeout
		Objects.train.emit()
	else:
		var test = Objects.Base_InfoPopup.instantiate()
		add_child(test)
		test.set_error("NO DATA TO TRAIN")


func _on_s_momentum_value_changed(value):
	momentum_label.text = "Momentum  (%.2f)  " % momentum_slider.value
	Objects.momentum = momentum_slider.value



func _on_slearning_rate_value_changed(value):
	learning_label.text = "Learning rate (%.2f)" % learning_slider.value
	Objects.learning_rate = learning_slider.value


func _on_t_error_value_changed(value):
	Objects.error_threshold = value


func _on_t_iterations_value_changed(value):
	Objects.limit_iter = value
