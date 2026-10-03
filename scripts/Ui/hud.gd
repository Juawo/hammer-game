extends Control

@onready var lifes: HBoxContainer = $MarginContainer/HBoxContainer/lifes
@onready var deaths: Label = $MarginContainer/HBoxContainer/time_and_deaths/deaths_container/deaths
@onready var time_count: Label = $MarginContainer/HBoxContainer/time_and_deaths/time_count


func update_life_visual(new_life_count: int) -> void:
	var lifes_nodes = lifes.get_children()
	lifes_nodes[new_life_count].modulate = "#2424245c"

func update_deaths(new_deaths_count: int) -> void:
	deaths.text = str(new_deaths_count)

func update_time_count(new_time: String) -> void:
	time_count.text = new_time
