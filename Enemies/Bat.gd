extends KinematicBody2D

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")

export var ACCELERATION = 300
export var MAX_SPEED = 40
export(float) var FRICTION = 0.2
export var WANDER_TARGET_RANGE = 4

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
onready var wanderController = $WanderController

func _ready():
	state = pick_random_state([IDLE, WANDER])
	

func _physics_process(delta):
	knockback = knockback.linear_interpolate(Vector2.ZERO, 0.1)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			velocity = velocity.linear_interpolate(Vector2.ZERO, FRICTION)
			seek_player()
			
			if wanderController.get_time_left() == 0:
				update_wander()
		WANDER:
			seek_player()
			if wanderController.get_time_left() == 0:
				update_wander()
			
			accelerate_towards_point(wanderController.target_position)
			
			if global_position.distance_to(wanderController.target_position) <= WANDER_TARGET_RANGE:
				update_wander()
			
		CHASE: 
			var player = playerDetectionZone.player
			if player != null:
				accelerate_towards_point(player.global_position)
			else:
				state = IDLE
				
	if softCollision.is_colliding():
		velocity = softCollision.get_push_vector() * 40
		
	velocity = move_and_slide(velocity)

func update_wander():
	state = pick_random_state([IDLE, WANDER])
	wanderController.start_wander_timer(rand_range(1, 3))

func accelerate_towards_point(point):
	var direction = global_position.direction_to(point)
	velocity = velocity.linear_interpolate(direction * MAX_SPEED, 0.1)
	sprite.flip_h = velocity.x < 0		

func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()

func _on_HurtBox_area_entered(area):
	stats.health -= area.damage
	knockback = area.knockback_vector * 200
	hurtbox.create_hit_effect()

func _on_Stats_no_health():
	queue_free()
	var enemyDeathEffect = EnemyDeathEffect.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position
	
