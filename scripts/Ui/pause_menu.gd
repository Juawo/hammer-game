extends CanvasLayer

var main_menu_scene := load("res://scenes/Ui/main_menu.tscn")

func show_pause_menu() -> void:
	# TODO : add juice animation
	print("hsdsahdasda")
	show()

func hide_pause_menu() -> void:
	# TODO : add juice animation
	hide()

func _on_back_btn_pressed() -> void:
	GameManager.toggle_pause()

func _on_return_btn_pressed() -> void:
	# TODO : add transition here
	get_tree().paused = false 
	GameManager.is_in_game = false
	
	hide_pause_menu()
	get_tree().change_scene_to_packed(main_menu_scene)
