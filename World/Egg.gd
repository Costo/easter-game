extends Node2D

export var FRAME = 1
onready var sprite = $Sprite

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.frame = FRAME


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
