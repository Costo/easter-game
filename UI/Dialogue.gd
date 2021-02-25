extends CanvasLayer

onready var halteLa = $HalteLa

func _ready():
	halteLa.stream.loop = false
	halteLa.play()


