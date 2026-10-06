extends CanvasLayer

@onready var color_rect: ColorRect = $ColorRect

func _ready() -> void:
	# Garante que a tela comece transparente
	color_rect.material.set_shader_parameter("progress", 0.0)
	color_rect.hide()

func transition_to_file(path: String) -> void:
	color_rect.show()
	var tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	
	# Anima o shader de 0 a 1 (fechando a tela)
	tween.tween_property(color_rect.material, "shader_parameter/progress", 1.0, 0.5)
	await tween.finished
	
	get_tree().change_scene_to_file(path)
	
	# Anima o shader de 1 a 0 (abrindo a tela na cena nova)
	var tween_out = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween_out.tween_property(color_rect.material, "shader_parameter/progress", 0.0, 0.5)
	await tween_out.finished
	color_rect.hide()
