extends Control

var first_level :=  "res://scenes/levels/level_base.tscn"


func _on_play_btn_pressed() -> void:
	# add transition here
	GameManager.start_new_game()
	TransitionManager.transition_to_file(first_level)

func _on_exit_btn_pressed() -> void:
	get_tree().quit()
