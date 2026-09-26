extends Marker2D
class_name EnemeySpawner

@export var enemy_types : Array[PackedScene]
@export var base_spawn_interval := 3.0

@onready var spawn_timer: Timer = $SpawnTimer
@onready var explosion_particle: CPUParticles2D = $ExplosionParticle
@onready var rise_particle: CPUParticles2D = $RiseParticle

var level_base : LevelBase

func _ready() -> void:
	level_base = get_tree().get_first_node_in_group("Level")
	spawn_timer.wait_time = base_spawn_interval

# don't use pure random! Improve this in the future
func spawn_random_enemy() -> void :
	if enemy_types.is_empty() : 
		print("MEPTYd")
		return
	
	var random_scene = enemy_types.pick_random()
	if random_scene :
		var enemy_instance = random_scene.instantiate()
		level_base.get_node("Entities").add_child(enemy_instance)
		enemy_instance.global_position = global_position
		
		level_base.register_enemy(enemy_instance)

func set_frenetic_mode(new_interval: float) -> void :
	spawn_timer.wait_time = new_interval
	spawn_timer.start()

func _on_spawn_timer_timeout() -> void:
	if level_base and level_base.can_spawn_enemy() :
		emit_particles()
		spawn_random_enemy()

func emit_particles() -> void :
	rise_particle.emitting = true
	await get_tree().create_timer(1).timeout
	explosion_particle.emitting = true
	rise_particle.emitting = false
	await explosion_particle.finished
