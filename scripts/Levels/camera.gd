extends Camera2D

var shake_strength := 0.0
var shake_fade := 5.0
@onready var dust_particles: CPUParticles2D = $DustParticle

func _ready() -> void:
	Events.shake_camera.connect(_on_request_shake)

func _on_request_shake(strenght: float) -> void:
	apply_shake(strenght)

func apply_shake(strength: float) -> void:
	shake_strength = strength
	
	# Dispara a cascata de partículas do teto
	dust_particles.restart()
	dust_particles.emitting = true

func _process(delta: float) -> void:
	if shake_strength > 0:
		# Reduz a força do tremor aos poucos
		shake_strength = lerpf(shake_strength, 0, shake_fade * delta)
		
		# Move a câmera aleatoriamente dentro da força atual
		offset = Vector2(
			randf_range(-shake_strength, shake_strength),
			randf_range(-shake_strength, shake_strength)
		)
