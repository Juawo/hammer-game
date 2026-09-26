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
		breakable_wall.wall_cracked.connect(trigger_wall_cracked_sequence)
		breakable_wall.wall_destroyed.connect(trigger_escape_sequence)
		
	if level_exit:
		level_exit.player_entered_exit.connect(_on_level_finished)

func can_spawn_enemy() -> bool :
	return current_enemies < max_enemies_allowed

func _on_enemy_died() -> void :
	current_enemies -= 1

func register_enemy(enemy: Node) -> void :
	current_enemies += 1
	enemy.tree_exited.connect(_on_enemy_died)

# when the wall can be take damage | get the game more frenetic
func trigger_wall_cracked_sequence() -> void:
	max_enemies_allowed *= 2
	update_spawners_generation(2.5)

# when the wall is destroyed | get the game the most frenetic momment
func trigger_escape_sequence() -> void :
	is_escaping = true
	max_enemies_allowed *= 2
	level_exit.switch_disable_exit()
	update_spawners_generation(1.5)
	label.visible = true
	var tween = create_tween().tween_property(label, "scale", Vector2(1.5,1.5), 1)
	tween.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_ELASTIC)

func update_spawners_generation(new_interval: float) -> void:
	var spawners = get_tree().get_nodes_in_group("Spawners")
	for spawner in spawners :
		if spawner.has_method("set_frenetic_mode") :
			spawner.set_frenetic_mode(new_interval)
	#  add juice and animations here, for get more frenetic emotion in the player

func _on_level_finished() -> void :
	print("NEXT LEVEL!")
	# add level transition / add juice/animation
