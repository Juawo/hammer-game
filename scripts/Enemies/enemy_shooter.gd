extends EnemyBase

@onready var wall_check: RayCast2D = $wall_check
@onready var sprite_2d: Sprite2D = $sprite
@onready var shoot_timer: Timer = $shoot_timer

var direction := 1.0
var projectile_scene : PackedScene = preload("uid://do7cj3138njd8")
var target_player : Node2D
var is_preparing_to_shoot := false
var stored_shoot_direction := 1.0

func _ready() -> void:
	super._ready()

func process_enemy_movement(_delta: float) -> void :
	if is_preparing_to_shoot :
		velocity.x = 0
		return
	
	if target_player:
		velocity.x = 0
		
		var direction_to_player = sign(target_player.global_position.x - global_position.x)
		if direction_to_player != 0 :
			sprite_2d.flip_h = direction_to_player < 0
			stored_shoot_direction = direction_to_player
		
		is_preparing_to_shoot = true
		shoot_timer.start()
		
	else :
		if wall_check.is_colliding():
			direction *= -1.0
			wall_check.target_position.x *= -1.0
			sprite_2d.flip_h = direction < 0
			 
		velocity.x = direction * speed


func shoot(shoot_dir : float) -> void :
	if not projectile_scene : return
	
	var projectile = projectile_scene.instantiate()
	get_parent().add_child(projectile)
	projectile.global_position = global_position
	
	if projectile.has_method("set_direction") :
		projectile.set_direction(Vector2(shoot_dir, 0))
	
func _on_shoot_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") :
		target_player = body

func _on_shoot_area_body_exited(body: Node2D) -> void:
	if body == target_player :
		target_player = null

func _on_shoot_timer_timeout() -> void:
	shoot(stored_shoot_direction)
	is_preparing_to_shoot = false
