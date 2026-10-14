extends StaticBody2D

signal wall_cracked
signal wall_destroyed

@export var max_health := 3
var current_health : int
var is_locked := true

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var hurtbox: Area2D = $Hurtbox
@onready var broken_sfx: AudioStreamPlayer2D = $BrokenSFX
@onready var cracked_sfx: AudioStreamPlayer2D = $CrackedSFX

const BREAKABLE_WALL_1 = preload("uid://ypmmahgu855c")
const BREAKABLE_WALL_2 = preload("uid://2vhhnope0mws")
const BREAKABLE_WALL_3 = preload("uid://dvag6rgoalon")

func _ready() -> void:
	current_health = max_health

func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area is Hitbox :
		take_damage(area.damage_amount)
		
		if owner.has_method("apply_knockback"):
			var push_dir = global_position.direction_to(area.owner.global_position)
			area.owner.apply_knockback(push_dir * 350.0)

func take_damage(amount: int) -> void :
	if is_locked :
		is_locked = false
		wall_cracked.emit()
		cracked_sfx.play()
		animate_hit(BREAKABLE_WALL_2)
		return
	
	current_health -= amount
	
	if current_health <= 0 :
		wall_destroyed.emit()
		broken_sfx.play()
		
		
		collision_layer = 0
		collision_mask = 0
		hurtbox.queue_free() 
		
		sprite_2d.material.set_shader_parameter("hit_flash_on", true)
		GameManager.frame_pause(0.25)
		var tween = create_tween().set_trans(Tween.TRANS_QUAD)
		
		tween.tween_property(sprite_2d, "position:y", sprite_2d.position.y - 30, 0.2).set_ease(Tween.EASE_OUT)
		tween.parallel().tween_property(sprite_2d, "rotation", deg_to_rad(randf_range(-45.0, 45.0)), 0.2)
		tween.tween_property(sprite_2d, "position:y", sprite_2d.position.y + 400, 0.5).set_ease(Tween.EASE_IN)
		tween.parallel().tween_property(sprite_2d, "modulate:a", 0.0, 0.5) # Fica invisível ao cair
		await get_tree().create_timer(0.15).timeout
		sprite_2d.material.set_shader_parameter("hit_flash_on", false)
		
		await tween.finished
		queue_free()
	else:
		GameManager.frame_pause(0.15)
		animate_hit(BREAKABLE_WALL_3)


func animate_hit(next_texture: Texture2D) -> void:
	sprite_2d.material.set_shader_parameter("hit_flash_on", true)
	
	var tween = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(sprite_2d, "scale", Vector2(1.3, 1.3), 0.1)
	
	tween.tween_callback(func(): 
		sprite_2d.texture = next_texture
		sprite_2d.material.set_shader_parameter("hit_flash_on", false)
	)
	
	tween.tween_property(sprite_2d, "scale", Vector2.ONE, 0.1)
