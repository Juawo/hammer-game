extends Node2D

const MAX_CHARGE_TIME = 1.0
const MAX_KNOCKBACK_FORCE = 300.0

var current_charge := 0.0
var is_charging := false

@onready var sprite: Sprite2D = $sprite
@onready var hammer_area: Area2D = $hammer_area
@onready var progress_bar : TextureProgressBar = $progress_bar
var player : CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_parent()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var mouse_pos := get_global_mouse_position()
	var target_angle := global_position.direction_to(mouse_pos).angle()
	rotation = lerp_angle(rotation, target_angle, 15.0 * delta)
	
	if Input.is_action_just_pressed("charge_hammer") :
		if not is_charging :
			is_charging = true
			player.set_hammer_charging(is_charging)
			# add camera juice here
		
		current_charge = min(current_charge + delta, MAX_CHARGE_TIME)
	
	if Input.is_action_just_released("charge_hammer"):
		is_charging = false
		player.set_hammer_charging(is_charging)
		# add camera juice here
		
		current_charge = 0.0
		update_visuals()
		

func update_visuals() -> void :
	var charge_ratio := current_charge / MAX_CHARGE_TIME
	progress_bar.value = charge_ratio * 100.0
