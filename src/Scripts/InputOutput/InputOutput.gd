extends TextureRect


@onready var nazwa = get_node("Label")
@onready var text_output = get_node("Control2/RichTextLabel")
signal update_output
var type = 'InputOutput'
var isRunning = false
var display: bool = isRunning
var index = 1
var isHovering
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


func _on_area_2d_mouse_entered():
	isHovering = true


func _on_area_2d_mouse_exited():
	isHovering = false


func set_nazwa(text):
	nazwa.text = str(text)


func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed and isHovering:
			Objects.create_inspector.emit(self)
