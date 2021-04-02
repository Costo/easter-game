extends CanvasLayer

var dialog = [
	"Halte-là ! C'est toi Jean-Carotte ?",
	"Welcome to my Godot dialog tutorial."]
	

onready var halteLa = $HalteLa

func _ready():
	halteLa.stream.loop = false
	halteLa.play()

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_ESCAPE:
			queue_free()
			
