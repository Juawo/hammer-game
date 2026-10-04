extends Control

var first_level :=  load("res://scenes/levels/level_base.tscn")


func _on_play_btn_pressed() -> void:
	# add transition here
	GameManager.start_new_game()
	get_tree().change_scene_to_packed(first_level)

func _on_exit_btn_pressed() -> void:
	get_tree().quit()
