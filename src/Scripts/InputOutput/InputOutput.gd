extends TextureRect



@onready var text_output = get_node("Control2/RichTextLabel")
signal update_output
var type = 'InputOutput'
var isRunning = false
var display: bool = isRunning
# NEURAL NETWORK IMPLEMENTATION

var previous_outputs = []
var output: float = 0 :
	get:
			return output
	set(value):
		previous_outputs.append(output)
		output = value
		update_output.emit()
		if len(previous_outputs) > 50:
			previous_outputs.pop_front()
var pos_x: int
var pos_y: int


# Called when the node enters the scene tree for the first time.
func _ready():
	text_output.visible = isRunning
	update_output.connect(update)


func clear_all():
	output = 0
	previous_outputs = []

func update():
	var to_format = "[center][font_size={14}]%.3f[/font_size][/center]"
	text_output.text =  to_format % [output]
	
func init(a):
	output = a

func is_running(run):
	text_output.visible = run
	isRunning = run
	display = run
