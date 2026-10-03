extends Control

@onready var deaths_count: Label = $VBoxContainer/PanelContainer/MarginContainer/VBoxContainer/deaths/deaths_count
@onready var time_count: Label = $VBoxContainer/PanelContainer/MarginContainer/VBoxContainer/time/time_count

var main_menu_scene := load("res://scenes/Ui/main_menu.tscn")

func _ready() -> void:
	# TODO : add animation when surge
	update_deaths(GameManager.total_deaths)
	update_time_count(GameManager.get_formated_time())

func update_deaths(new_deaths_count: int) -> void:
	# TODO : add count animation
	deaths_count.text = str(new_deaths_count) + "x"

func update_time_count(new_time: String) -> void:
	# TODO : add count animation
	time_count.text = new_time

func _on_return_btn_pressed() -> void:
	# TODO : add transition here
	get_tree().change_scene_to_packed(main_menu_scene)
