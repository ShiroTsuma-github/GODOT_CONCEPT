extends Node

signal create_inspector
signal perceptron_pressed(perceptron)
signal simulate_running

var Base_Start_Window = load("res://src/Scenes/NetworkCreator.tscn")
var Base_Start_Window_NEW = false
var Base_Start_Window_LOAD = false
var Base_Start_Window_BLOCK_CLOSE = false
var Base_Network = load("res://src/Scenes/Network.tscn")
var Base_Inspector = load("res://src/Scenes/Inspector.tscn")
var Base_Perceptron = load("res://src/Scenes/Perceptron.tscn")
var Base_InputOutput = load("res://src/Scenes/InputOutput.tscn")

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
