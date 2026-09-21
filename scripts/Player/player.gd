extends CharacterBody2D

const MAX_SPEED = 500.0
const JUMP_VELOCITY = -550.0
const ACCELERATION = 1500.0
const FRICTION = 2000.0

var speed_modifier := 1.0
var jump_modifier := 1.0

const INVULNERABILITY_TIME = 2

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var label: Label = $Label

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
		velocity.y = (JUMP_VELOCITY * jump_modifier)
		
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = move_toward(velocity.x, direction * (MAX_SPEED * speed_modifier), ACCELERATION * delta)
		sprite_2d.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)

	if knockback_velocity != Vector2.ZERO :
		velocity += knockback_velocity
		knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, FRICTION * 1.5 * delta)
		
	move_and_slide()
	

func apply_knockback(force : Vector2) -> void :
	knockback_velocity = force

func set_hammer_charging(is_charging : bool) -> void :
	if is_charging :
		speed_modifier = 0.4
		jump_modifier = 0.6
	else :
		speed_modifier = 1.0
		jump_modifier = 1.0

func take_damage(value : int) -> void :
	if is_invulnerable :
		return
	current_health -= value
	label.text = "life : " + str(current_health)
	
	if current_health <= 0 :
		die()
	else :
		trigger_invulnerability()

func trigger_invulnerability() -> void :
	is_invulnerable = true
	# add visuals to player understand that he is invulenrable 
	await get_tree().create_timer(INVULNERABILITY_TIME, false).timeout
	
	is_invulnerable = false

func die() -> void :
	# Add visuals and connect to GameManager
	queue_free()

func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("DamageDealer") :
		take_damage(area.damage_amount)
