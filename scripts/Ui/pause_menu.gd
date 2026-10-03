extends Control

var main_menu_scene := load("res://scenes/Ui/main_menu.tscn")

func show_pause_menu() -> void:
	# TODO : add juice animation
	show()

func hide_pause_menu() -> void:
	# TODO : add juice animation
	hide()

func _on_back_btn_pressed() -> void:
	hide_pause_menu()
	GameManager.toggle_pause()

func _on_return_btn_pressed() -> void:
	# TODO : add transition here
	hide_pause_menu()
	get_tree().change_scene_to_packed(main_menu_scene)
