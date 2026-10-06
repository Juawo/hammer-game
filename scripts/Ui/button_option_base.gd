extends Button

var tween: Tween

func _ready() -> void:
	mouse_entered.connect(_on_hover)
	mouse_exited.connect(_on_exit)
	focus_entered.connect(_on_hover) # Para navegação por teclado
	focus_exited.connect(_on_exit)

func _on_hover() -> void:
	pivot_offset = size / 2.0 
	if tween: tween.kill()
	tween = create_tween().set_parallel(true).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	
	# Cresce o botão
	tween.tween_property(self, "scale", Vector2(1.15, 1.15), 0.2)
	
	# Rotação aleatória e imediata correção (dá uma "tremida" suculenta)
	var random_angle = deg_to_rad(randf_range(-4.0, 4.0))
	tween.tween_property(self, "rotation", random_angle, 0.1)
	tween.chain().tween_property(self, "rotation", 0.0, 0.1) # O chain() faz executar DEPOIS do paralelo

func _on_exit() -> void:
	if tween: tween.kill()
	tween = create_tween().set_parallel(true).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector2.ONE, 0.2)
	tween.tween_property(self, "rotation", 0.0, 0.2)
