class_name EnemyBase extends CharacterBody2D

@export var max_health: int = 3
@export var speed: float = 100.0
@export var knockback_resistance: float = 1.0
@export var sprite_node : Node2D # Certifique-se de arrastar o AnimatedSprite2D para cá no Inspetor!

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
	
	if current_health <= 0:
		die()
	else:
		# Chama a animação solta, sem travar o código com await
		animate_take_damage()

func animate_take_damage() -> void :
	if not sprite_node: return
	
	# 1. Liga o flash branco no material do sprite
	sprite_node.material.set_shader_parameter("hit_flash_on", true)
	
	var tween = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	# Cresce e volta bem rápido (frenético!)
	tween.tween_property(sprite_node, "scale", Vector2(1.3, 1.3), 0.1)
	tween.tween_property(sprite_node, "scale", Vector2.ONE, 0.1)
	
	# 2. Desliga o flash branco no exato momento que a escala volta ao normal
	tween.tween_callback(func(): sprite_node.material.set_shader_parameter("hit_flash_on", false))

func die() -> void:
	# Trava a inteligência do inimigo e desliga colisões para ele cair pelo chão
	set_physics_process(false)
	collision_layer = 0
	collision_mask = 0
	
	# Animação de ser arremessado e cair rodando
	var tween = create_tween().set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "position:y", position.y - 40, 0.2).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(sprite_node, "rotation", deg_to_rad(180), 0.5)
	tween.tween_property(self, "position:y", position.y + 600, 0.8).set_ease(Tween.EASE_IN)
	
	await tween.finished
	queue_free()
