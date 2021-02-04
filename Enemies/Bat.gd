extends KinematicBody2D

var knockback = Vector2.ZERO

func _physics_process(delta):
	knockback = knockback.linear_interpolate(Vector2.ZERO, 0.1)
	knockback = move_and_slide(knockback)
	
func _on_HurtBox_area_entered(area):
	knockback = area.knockback_vector * 200
