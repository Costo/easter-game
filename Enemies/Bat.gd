extends KinematicBody2D

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")

enum {
	IDLE,
	WANDER,
	CHASE
}

onready var stats = $Stats
var knockback = Vector2.ZERO
var state = IDLE

func _physics_process(delta):
	knockback = knockback.linear_interpolate(Vector2.ZERO, 0.1)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			pass
		WANDER:
			pass
		CHASE: 
			pass
		
	
func _on_HurtBox_area_entered(area):
	stats.health -= area.damage
	knockback = area.knockback_vector * 200


func _on_Stats_no_health():
	queue_free()
	var enemyDeathEffect = EnemyDeathEffect.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position
	
