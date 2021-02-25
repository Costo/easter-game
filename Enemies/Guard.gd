extends KinematicBody2D

const Dialogue = preload("res://UI/Dialogue.tscn")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_HitBox_area_entered(area):
	var dialogue = Dialogue.instance()
	get_tree().current_scene.add_child(dialogue)

