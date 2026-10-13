extends Node

var bgm_player : AudioStreamPlayer

func _ready() -> void:
	var player = AudioStreamPlayer.new()
	player.name = "BGMPlayer"
	player.bus = "BGM"
	add_child(player)
	bgm_player = player

func play_music(stream: AudioStream) -> void:
	if bgm_player.stream == stream and bgm_player.playing:
		return
	bgm_player.stream = stream
	bgm_player.play()

func stop_music() -> void:
	bgm_player.stop()

func play_sfx(stream: AudioStream, pitch_variance := 0.0) -> void:
	var sfx_player = AudioStreamPlayer.new()
	sfx_player.stream = stream
	sfx_player.bus = "SFX"
	
	if pitch_variance > 0.0:
		sfx_player.pitch_scale = randf_range(1.0 - pitch_variance, 1.0 + pitch_variance)
		
	add_child(sfx_player)
	sfx_player.play()
	
	sfx_player.finished.connect(sfx_player.queue_free)
