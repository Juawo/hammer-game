extends Node2D

const MAX_CHARGE_TIME = 1.0
const MIN_CHARGE_TIME = 0.1
const MAX_KNOCKBACK_FORCE = 300.0

const ORBIT_SPEED = 15.0
const MAX_ORBIT_DISTANCE = 300.0 #position.x do hammer_area

var orbit_speed_modifier = 1
var current_charge := 0.0
var is_charging := false

var target_scale_ui := 0.5
var ui_tween : Tween

@onready var sprite: Sprite2D = $sprite
@onready var hammer_area: Area2D = $hammer_area
@onready var progress_bar: TextureProgressBar = $sprite/progress_bar
@onready var ray_cast_2d: RayCast2D = $RayCast2D

var player : CharacterBody2D

func _ready() -> void:
	player = get_parent().get_parent()
	
	progress_bar.scale = Vector2.ZERO 
	
func _physics_process(delta: float) -> void:
	var mouse_pos := get_global_mouse_position()
	var target_angle := global_position.direction_to(mouse_pos).angle()
	rotation = lerp_angle(rotation, target_angle, (ORBIT_SPEED * orbit_speed_modifier) * delta)
	
	ray_cast_2d.target_position = Vector2.RIGHT * MAX_ORBIT_DISTANCE
	ray_cast_2d.force_raycast_update()
	
	if ray_cast_2d.is_colliding():
		var distance_to_wall := to_local(ray_cast_2d.get_collision_point()).length()
		var clamped_distance = max(0.0, distance_to_wall - 64)
		
		sprite.position.x = clamped_distance
		hammer_area.position.x = clamped_distance
	else:
		sprite.position.x = MAX_ORBIT_DISTANCE
		hammer_area.position.x = MAX_ORBIT_DISTANCE
		
	var ui_offset = Vector2(0, -60) # altura da progress
	progress_bar.global_position = sprite.global_position + ui_offset - (progress_bar.pivot_offset * progress_bar.scale)
	
	if Input.is_action_pressed("charge_hammer"):
		if not is_charging:
			is_charging = true
			orbit_speed_modifier = 0.3
			player.set_hammer_charging(is_charging)
			
			if ui_tween:
				ui_tween.kill()
			
			ui_tween = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
			ui_tween.tween_property(progress_bar, "scale", Vector2(target_scale_ui, target_scale_ui), 0.25)
			
		current_charge = min(current_charge + delta, MAX_CHARGE_TIME)
		update_visuals()
	
	if Input.is_action_just_released("charge_hammer"):
		is_charging = false
		orbit_speed_modifier = 1
		player.set_hammer_charging(is_charging)
		
		if ui_tween:
			ui_tween.kill()
	
		ui_tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
		ui_tween.tween_property(progress_bar, "scale", Vector2.ZERO, 0.15)
			
		execute_strike()
		
		current_charge = 0.0
		update_visuals()
	
func execute_strike() -> void:
	var charge_ratio = current_charge / MAX_CHARGE_TIME
	print(charge_ratio)
	if charge_ratio < MIN_CHARGE_TIME: return
	
	var hit_something := false
	var bodies := hammer_area.get_overlapping_bodies()
	
	for body in bodies:
		if body != player:
			hit_something = true
			if body.has_method("take_damage"):
				var damage := int(ceil(3 * charge_ratio))
				body.take_damage(damage)
	
	if hit_something:
		var strike_direction := Vector2.RIGHT.rotated(rotation)
		var knockback_direction := -strike_direction
		var applied_force = MAX_KNOCKBACK_FORCE * charge_ratio
		
		player.apply_knockback(knockback_direction * applied_force)

func update_visuals() -> void:
	var charge_ratio := current_charge / MAX_CHARGE_TIME
	progress_bar.value = charge_ratio * 100.0
