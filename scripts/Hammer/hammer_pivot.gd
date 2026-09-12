extends Node2D

const MAX_CHARGE_TIME = 2.0
const MIN_CHARGE_TIME = 0.1
const MAX_KNOCKBACK_FORCE = 300.0

const ORBIT_SPEED = 15.0
const MAX_ORBIT_DISTANCE = 400.0 #position.x do hammer_area

var orbit_speed_modifier = 1
var current_charge := 0.0
var is_charging := false

@onready var sprite: Sprite2D = $sprite
@onready var hammer_area: Area2D = $hammer_area
@onready var progress_bar : TextureProgressBar = $progress_bar
@onready var ray_cast_2d: RayCast2D = $RayCast2D

var player : CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_parent().get_parent()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var mouse_pos := get_global_mouse_position()
	var target_angle := global_position.direction_to(mouse_pos).angle()
	rotation = lerp_angle(rotation, target_angle, (ORBIT_SPEED * orbit_speed_modifier) * delta)
	
	ray_cast_2d.target_position = Vector2.RIGHT * MAX_ORBIT_DISTANCE
	ray_cast_2d.force_raycast_update()
	
	if ray_cast_2d.is_colliding():
		var distance_to_wall := to_local(ray_cast_2d.get_collision_point()).length()
		
		# Substitua "20.0" pela metade do tamanho exato do seu sprite do martelo.
		# A função max() garante que, no pior cenário, a distância zere em vez de ficar negativa.
		var clamped_distance = max(0.0, distance_to_wall - 64)
		
		sprite.position.x = clamped_distance
		hammer_area.position.x = clamped_distance
		progress_bar.position.x = clamped_distance
	else:
		# Caminho livre, mantém o martelo na distância original
		sprite.position.x = MAX_ORBIT_DISTANCE
		hammer_area.position.x = MAX_ORBIT_DISTANCE
		progress_bar.position.x = MAX_ORBIT_DISTANCE
		
	
	if Input.is_action_pressed("charge_hammer") :
		if not is_charging :
			is_charging = true
			orbit_speed_modifier = 0.3
			player.set_hammer_charging(is_charging)
			# add camera juice here
		
		current_charge = min(current_charge + delta, MAX_CHARGE_TIME)
		update_visuals()
	
	if Input.is_action_just_released("charge_hammer"):
		is_charging = false
		orbit_speed_modifier = 1
		player.set_hammer_charging(is_charging)
		# add camera juice here
		
		execute_strike()
		
		current_charge = 0.0
		update_visuals()
		

func execute_strike() -> void :
	var charge_ratio = current_charge / MAX_CHARGE_TIME
	print(charge_ratio)
	if charge_ratio < MIN_CHARGE_TIME: return
	var hit_something := false
	var bodies := hammer_area.get_overlapping_bodies()
	
	for body in bodies :
		if body != player :
			hit_something = true
			
			if body.has_method("take_damage") :
				var damage := int(ceil(3 * charge_ratio))
				body.take_damage(damage)
	
	if hit_something :
		var strike_direction := Vector2.RIGHT.rotated(rotation)
		var knockback_direction := -strike_direction
		
		var applied_force = MAX_KNOCKBACK_FORCE * charge_ratio
		
		player.apply_knockback(knockback_direction * applied_force)
		# add juice here

func update_visuals() -> void :
	var charge_ratio := current_charge / MAX_CHARGE_TIME
	progress_bar.value = charge_ratio * 100.0
