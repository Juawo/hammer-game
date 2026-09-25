extends Area2D

signal player_entered_exit

@onready var cpu_particles_2d: CPUParticles2D = $CPUParticles2D

var is_disabled := false

func switch_disable_exit() -> void :
	is_disabled = !is_disabled
	self.monitoring = is_disabled
	cpu_particles_2d.emitting = is_disabled

func _on_body_entered(_body: Node2D) -> void:
	player_entered_exit.emit()
