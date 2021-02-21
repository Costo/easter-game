extends KinematicBody2D


export var MAXSPEED = 100
export var ACCELERATION = 10

enum {
	MOVE,
	ATTACK
}

var state = MOVE
var velocity = Vector2.ZERO
var stats = PlayerStats

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = $AnimationTree.get("parameters/playback")
onready var swordHitbox = $HitBoxPivot/SwordHitbox
onready var hurtbox = $HurtBox

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	stats.connect("no_health", self, "queue_free")
	swordHitbox.knockback_vector = Vector2.ZERO
	animationTree.active = true


func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		ATTACK:
			attack_state(delta)


func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if (input_vector == Vector2.ZERO):
		animationState.travel("Idle")
		velocity = velocity.linear_interpolate(Vector2.ZERO, 0.5)
	else:
		# Set knockback vector in Hitbox
		swordHitbox.knockback_vector = input_vector
		
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationState.travel("Run")
		velocity += input_vector * ACCELERATION
		velocity = velocity.clamped(MAXSPEED)

	velocity = move_and_slide(velocity, Vector2(0, -1))
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
		

func attack_state(delta):
	velocity = Vector2.ZERO
	animationState.travel("Attack")

func attack_animation_finished():
	state = MOVE


func _on_HurtBox_area_entered(area):
	stats.health -= 1
	hurtbox.start_invicibility(0.5)
	hurtbox.create_hit_effect()
	
