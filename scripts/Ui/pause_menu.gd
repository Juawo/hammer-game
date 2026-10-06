extends CanvasLayer

var main_menu_scene := "res://scenes/Ui/main_menu.tscn"
@onready var main_container: MarginContainer = $MarginContainer
@onready var bg: ColorRect = $background

func show_pause_menu() -> void:
	show()
	main_container.scale = Vector2.ZERO
	
	var tween = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(main_container, "scale", Vector2.ONE, 0.3)
	
	# Anima a cor de fundo (ColorRect) escurecendo suavemente
	bg.modulate.a = 0
	tween.parallel().tween_property(bg, "modulate:a", 1.0, 0.2)

func hide_pause_menu() -> void:
	var tween = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	
	tween.tween_property(main_container, "scale", Vector2.ZERO, 0.2)
	tween.parallel().tween_property(bg, "modulate:a", 0.0, 0.2)
	
	await tween.finished
	hide()

func _on_back_btn_pressed() -> void:
	GameManager.toggle_pause()

func _on_return_btn_pressed() -> void:
	get_tree().paused = false 
	GameManager.is_in_game = false
	
	hide_pause_menu()
	TransitionManager.transition_to_file(main_menu_scene)
