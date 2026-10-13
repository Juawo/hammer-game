extends Node2D
class_name LevelBase

@onready var breakable_wall: StaticBody2D = $Environment/BreakableWall
@onready var level_exit: Area2D = $Environment/LevelExit

@export var max_enemies_allowed := 10
@export var next_level : PackedScene

var current_enemies := 0
var is_escaping := false

func _ready() -> void:
	if breakable_wall:
		breakable_wall.wall_cracked.connect(trigger_wall_cracked_sequence)
		breakable_wall.wall_destroyed.connect(trigger_escape_sequence)
		
	if level_exit:
		level_exit.player_entered_exit.connect(_on_level_finished)
	
	Events.level_started.emit()

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
	Events.shake_camera.emit(15.0)

# when the wall is destroyed | get the game the most frenetic momment
func trigger_escape_sequence() -> void :
	is_escaping = true
	max_enemies_allowed *= 2
	level_exit.switch_disable_exit()
	update_spawners_generation(1.5)
	Events.shake_camera.emit(30.0)
	

func update_spawners_generation(new_interval: float) -> void:
	var spawners = get_tree().get_nodes_in_group("Spawners")
	for spawner in spawners :
		if spawner.has_method("set_frenetic_mode") :
			spawner.set_frenetic_mode(new_interval)
	#  add juice and animations here, for get more frenetic emotion in the player

func _on_level_finished() -> void :
	print("NEXT LEVEL!")
	# add level transition / add juice/animation
	
	if next_level != null :
		print("NO HAVE NEXT LEVEL")
		get_tree().change_scene_to_packed(next_level)
	else :
		GameManager.win_game()
