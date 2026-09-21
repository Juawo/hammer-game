class_name EnemyBase extends CharacterBody2D

@export var max_health: int = 3
@export var speed: float = 150.0
@export var knockback_resistance: float = 1.0

var current_health: int
var knockback_velocity := Vector2.ZERO
const FRICTION = 2000.0

func _ready() -> void:
	current_health = max_health

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if knockback_velocity != Vector2.ZERO:
		velocity.x = knockback_velocity.x
		knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, FRICTION * 1.5 * delta)
	else:
		process_enemy_movement(delta)

	move_and_slide()

func process_enemy_movement(_delta: float) -> void :
	pass

func apply_knockback(force: Vector2) -> void :
	knockback_velocity = force / knockback_resistance

func take_damage(amount: int) -> void:
	current_health -= amount
	# Adicione juice 
	if current_health <= 0:
		die()

func die() -> void:
	# Som de explosão arcade e pontuação
	queue_free()
