extends StaticBody2D

signal wall_cracked
signal wall_destroyed

@export var max_health := 3
var current_health : int
var is_locked := true

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var hurtbox: Area2D = $Hurtbox

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
		#add animations/juice here
		var tween = create_tween().tween_property(self, "scale", Vector2(1.2,1.2), 1.67)
		tween.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_ELASTIC)
		await tween.finished
		var tween_out = create_tween().tween_property(self, "scale", Vector2(0.8,0.8), 1)
		tween_out.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
		return
	
	current_health -= amount
	if current_health <= 0 :
		wall_destroyed.emit()
		#add animations/juice here
		queue_free()
