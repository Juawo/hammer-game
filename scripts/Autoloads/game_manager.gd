extends Node

var win_game_scene := load("res://scripts/Levels/level_base.gd")
var total_deaths := 0
var total_time := 0.0
var is_run_active := false

func _process(delta: float) -> void:
	if is_run_active :
		total_time += delta

func start_new_game() -> void:
	total_deaths = 0
	total_time = 0.0

func register_death() -> void :
	total_deaths += 1
	# add scene transition with juice
	get_tree().reload_current_scene()

func win_game() -> void :
	is_run_active = false
	# add transition between scenes
	get_tree().change_scene_to_packed(win_game_scene)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause_game") and is_run_active:
		toggle_pause()

func toggle_pause() -> void:
	var new_pause_state = not get_tree().paused
	get_tree().paused = new_pause_state
	
	if new_pause_state:
		print("Jogo Pausado - Abrir UI de Pause")
		#  exibe a Tela de Pause
	else:
		print("Jogo Retomado")
		#  esconde a Tela de Pause

func get_formated_time() -> String:
	var minutes := int(total_time) / 60
	var seconds := int(total_time) % 60
	var milliseconds := int((total_time - int(total_time)) * 100) 
	return "%02d:%02d:%02d" % [minutes, seconds, milliseconds]
