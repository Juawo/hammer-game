extends Node2D
class_name LevelBase

@onready var breakable_wall: StaticBody2D = $Environment/BreakableWall
@onready var level_exit: Area2D = $Environment/LevelExit
@onready var label: Label = $CanvasLayer/Label

@export var max_enemies_allowed := 10

var current_enemies := 0
var is_escaping := false

func _ready() -> void:
	if breakable_wall:
		breakable_wall.wall_destroyed.connect(trigger_escape_sequence)
		
	if level_exit:
		level_exit.player_entered_exit.connect(_on_level_finished)

func can_spawn_enemy() -> bool :
	return current_enemies < max_enemies_allowed

func on_enemy_died() -> void :
	current_enemies -= 1

func trigger_escape_sequence() -> void :
	is_escaping = true
	max_enemies_allowed *= 2
	level_exit.switch_disable_exit()
	label.visible = true
	var tween = create_tween().tween_property(label, "scale", Vector2(1.5,1.5), 1)
	tween.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_ELASTIC)
	

func _on_level_finished() -> void :
	print("NEXT LEVEL!")
	# add level transition / add juice/animation
	
