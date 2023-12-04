extends Node

signal create_inspector(object)
signal perceptron_pressed(pos_x, pos_y)
signal weights_randomized
signal weights_zeroed
signal simulate_running
signal csv_selected(path)
signal netork_selected(path)
signal run(should_run)
signal test(values)
signal train

var Base_Start_Window = load("res://src/Scenes/NetworkCreator.tscn")
var Base_Start_Window_NEW = false
var Base_Start_Window_LOAD = false
var Base_Start_Window_BLOCK_CLOSE = false
var VALID_CSV_DATA = false
var Base_Network = load("res://src/Scenes/Network.tscn")
var Base_Inspector = load("res://src/Scenes/Inspector.tscn")
var Base_Perceptron = load("res://src/Scenes/Perceptron.tscn")
var Base_InputOutput = load("res://src/Scenes/InputOutput.tscn")
var Base_Layer = load("res://src/Scenes/Layer.tscn")
var Base_NetworkTester = load("res://src/Scenes/NetworkTester.tscn")
var Base_TesterInputEdit = load("res://src/Scenes/TesterInputEdit.tscn")
var Base_FileDialog = load("res://src/Scenes/FileDialog.tscn")
var Base_InfoPopup = load("res://src/Scenes/InformationPopup.tscn")

var Network = null

var momentum = 0.3
var learning_rate = 0.1
var limit_iter = 100
var error_threshold = 0.01

enum ActivationFunctions{
	STEP_UNIPOLAR,
	STEP_BIPOLAR,
	SIGMOID_UNIPOLAR,
	SIGMOID_BIPOLAR,
	IDENTITY,
	RELU,
	RELU_LEAKY,
	RELU_PARAMETRIC,
	SOFTPLUS}

enum LayerTypes{
	INPUT,
	OUTPUT,
	PERC
}

func mul_list(l, i):
	var res = []
	for index in range(i):
		res.append(l)
	return res
		
func sum(array):
	var _sum = 0.0
	for element in array:
		_sum += element
	return _sum
