extends Camera2D

onready var top_left = $Limits/TopLeft
onready var bottom_right = $Limits/BottomRight

# Called when the node enters the scene tree for the first time.
func _ready():
	limit_top = top_left.position.y
	limit_left = top_left.position.x
	limit_right = bottom_right.position.x
	limit_bottom = bottom_right.position.y


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
