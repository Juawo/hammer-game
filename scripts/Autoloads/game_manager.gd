extends Node

var win_game_scene := "res://scenes/Ui/finish_game.tscn"
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
	
	const GAME_MUSIC = preload("uid://doshqt83p03i2")

	SoundManager.play_music(GAME_MUSIC)

func _on_level_started() -> void:
	toggle_timer_count(true)
	is_in_game = true

func register_death() -> void :
	Engine.time_scale = 1
	total_deaths += 1
	toggle_timer_count(false)
	TransitionManager.transition_to_file(get_tree().current_scene.scene_file_path)
	
func win_game() -> void :
	toggle_timer_count(false)
	is_in_game = false
	TransitionManager.transition_to_file(win_game_scene)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause_game") and is_in_game:
		toggle_pause()

func toggle_pause() -> void:
	var new_pause_state = not get_tree().paused
	get_tree().paused = new_pause_state
	
	if new_pause_state:
		toggle_timer_count(false)
		PauseMenu.show_pause_menu()
	else:
		toggle_timer_count(true)
		PauseMenu.hide_pause_menu()

func toggle_timer_count(is_active: bool) -> void:
	is_run_active = is_active

func frame_pause(duration: float = 0.05) -> void:
	Engine.time_scale = 0.0
	await get_tree().create_timer(duration, true, false, true).timeout
	Engine.time_scale = 1.0

func get_formated_time() -> String:
	var minutes := int(total_time) / 60
	var seconds := int(total_time) % 60
	var milliseconds := int((total_time - int(total_time)) * 100) 
	return "%02d:%02d:%02d" % [minutes, seconds, milliseconds]
