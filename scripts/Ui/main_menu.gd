extends Control

var first_level :=  "res://scenes/levels/level_base.tscn"
const MUSIC_1 = preload("res://assets/audio/Music/main-menu-music.ogg")
const UI_CLICK = preload("uid://bamv7qaitt0vj")

func _ready() -> void:
	SoundManager.play_music(MUSIC_1)

func _on_play_btn_pressed() -> void:
	GameManager.start_new_game()
	SoundManager.play_sfx(UI_CLICK, 0.1)

	TransitionManager.transition_to_file(first_level)

func _on_exit_btn_pressed() -> void:
	get_tree().quit()

func _on_logo_pressed() -> void:
	OS.shell_open("https://www.instagram.com/funaxys/")
