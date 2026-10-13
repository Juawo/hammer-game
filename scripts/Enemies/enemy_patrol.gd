extends EnemyBase

@onready var wall_check: RayCast2D = $wall_check
@onready var sprite_2d: Sprite2D = $sprite
@onready var hitbox: Area2D = $Hitbox

var direction := 1.0

func _ready() -> void:
	super._ready()

func process_enemy_movement(_delta: float) -> void :
	if wall_check.is_colliding():
		direction *= -1.0
		wall_check.target_position.x *= -1.0
		sprite_2d.flip_h = direction < 0
	velocity.x = direction * speed
