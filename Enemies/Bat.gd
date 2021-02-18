extends KinematicBody2D

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")

export var ACCELERATION = 300
export var MAX_SPEED = 50
export(float) var FRICTION = 0.2

enum {
	IDLE,
	WANDER,
	CHASE
}

var knockback = Vector2.ZERO
var velocity = Vector2.ZERO
var state = IDLE

onready var stats = $Stats
onready var playerDetectionZone = $PlayerDetectionZone
onready var sprite = $Sprite
onready var hurtbox = $HurtBox
onready var softCollision = $SoftCollision

func _physics_process(delta):
	knockback = knockback.linear_interpolate(Vector2.ZERO, 0.1)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			velocity = velocity.linear_interpolate(Vector2.ZERO, FRICTION)
			seek_player()
		WANDER:
			pass
		CHASE: 
			var player = playerDetectionZone.player
			if player != null:
				var direction = (player.global_position - global_position).normalized()
				velocity = velocity.linear_interpolate(direction * MAX_SPEED, 0.1)
			else:
				state = IDLE
			sprite.flip_h = velocity.x < 0
	if softCollision.is_colliding():
		velocity = softCollision.get_push_vector() * 40
		
	velocity = move_and_slide(velocity)
		

func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE

func _on_HurtBox_area_entered(area):
	stats.health -= area.damage
	knockback = area.knockback_vector * 200
	hurtbox.create_hit_effect()

func _on_Stats_no_health():
	queue_free()
	var enemyDeathEffect = EnemyDeathEffect.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position
	
