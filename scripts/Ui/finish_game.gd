extends Control

@onready var deaths_count: Label = $VBoxContainer/PanelContainer/MarginContainer/VBoxContainer/deaths/deaths_count
@onready var time_count: Label = $VBoxContainer/PanelContainer/MarginContainer/VBoxContainer/time/time_count

var main_menu_scene := "res://scenes/Ui/main_menu.tscn"

func _ready() -> void:
	deaths_count.text = "0x"
	time_count.text = "00:00:00"
	animate_results(GameManager.total_deaths, GameManager.total_time)

func animate_results(final_deaths: int, final_time: float) -> void:
	var tween = create_tween().set_parallel(true)
	
	# Conta as mortes (de 0 até o valor real) durando 1.5 segundos
	tween.tween_method(_update_death_text, 0, final_deaths, 1.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	
	# Conta o tempo
	tween.tween_method(_update_time_text, 0.0, final_time, 2.0).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

func _update_death_text(value: int) -> void:
	deaths_count.text = str(value) + "x"

func _update_time_text(value: float) -> void:
	# Reutiliza a função de formatação do seu GameManager
	var minutes := int(value) / 60
	var seconds := int(value) % 60
	var milliseconds := int((value - int(value)) * 100)
	time_count.text = "%02d:%02d:%02d" % [minutes, seconds, milliseconds]

func _on_return_btn_pressed() -> void:
	TransitionManager.transition_to_file(main_menu_scene)
