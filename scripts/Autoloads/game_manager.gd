extends Node

var win_game_scene := load("res://scenes/Ui/finish_game.tscn")
var total_deaths := 0
var total_time := 0.0
var is_run_active := false
var is_in_game := false

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	Events.level_started.connect(_on_level_started)

func _process(delta: float) -> void:
	if is_run_active :
		total_time += delta

func start_new_game() -> void:
	total_deaths = 0
	total_time = 0.0

func _on_level_started() -> void:
	print("starded")
	toggle_timer_count()
	print("COUNT : ", is_run_active)
	is_in_game = true

func register_death() -> void :
	# TODO : add scene transition with juice
	total_deaths += 1
	toggle_timer_count()
	TransitionManager.transition_to_file(get_tree().current_scene.scene_file_path)

func win_game() -> void :
	# TODO :  add transition between scenes
	toggle_timer_count()
	is_in_game = false
	get_tree().change_scene_to_packed(win_game_scene)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause_game") and is_in_game:
		toggle_pause()

func toggle_pause() -> void:
	var new_pause_state = not get_tree().paused
	get_tree().paused = new_pause_state
	
	if new_pause_state:
		print("Jogo Pausado - Abrir UI de Pause")
		toggle_timer_count()
		PauseMenu.show_pause_menu()
	else:
		print("Jogo Retomado")
		toggle_timer_count()
		PauseMenu.hide_pause_menu()

func toggle_timer_count() -> void:
	is_run_active = !is_run_active

func get_formated_time() -> String:
	var minutes := int(total_time) / 60
	var seconds := int(total_time) % 60
	var milliseconds := int((total_time - int(total_time)) * 100) 
	return "%02d:%02d:%02d" % [minutes, seconds, milliseconds]
