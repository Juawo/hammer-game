extends CharacterBody2D

const MAX_SPEED = 500.0
const JUMP_VELOCITY = -550.0
const ACCELERATION = 1500.0
const FRICTION = 2000.0

const INVULNERABILITY_TIME = 2

@onready var sprite_2d: Sprite2D = $Sprite2D

var max_health = 3
var current_health := 3
var is_invulnerable := false

var knockback_velocity := Vector2.ZERO

func _ready() -> void:
	current_health = max_health

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = move_toward(velocity.x, direction * MAX_SPEED, ACCELERATION * delta)
		sprite_2d.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)

	if knockback_velocity != Vector2.ZERO :
		velocity += knockback_velocity
		knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, FRICTION * 1.5 * delta)
		
	move_and_slide()

func apply_knocknack(force : Vector2) -> void :
	knockback_velocity = force

func take_damage(value : int) -> void :
	if is_invulnerable :
		return
	
	current_health -= value
	
	if current_health <= 0 :
		die()
	else :
		trigger_invulnerability()

func trigger_invulnerability() -> void :
	is_invulnerable = true
	
	await get_tree().create_timer(INVULNERABILITY_TIME, false).timeout
	
	is_invulnerable = false

func die() -> void :
	# Add visuals and connect to GameManager
	queue_free()
