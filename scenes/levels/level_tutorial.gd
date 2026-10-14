extends LevelBase

@onready var player_sections: HBoxContainer = $UI/tutorial_panel/MarginContainer/player_sections
@onready var level_sections: VBoxContainer = $UI/tutorial_panel/MarginContainer/level_sections

func _on_wall_areatrigger_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") :
		player_sections.visible = false
		level_sections.visible = true


func _on_wall_areatrigger_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player") :
		player_sections.visible = true
		level_sections.visible = false
