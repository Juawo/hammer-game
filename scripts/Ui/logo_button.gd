extends TextureButton

@export var float_distance: float = 15
@export var float_duration: float = 0.8
@export var hover_scale: Vector2 = Vector2(1.1, 1.1)
@export var scale_duration: float = 0.2

var base_y: float
var float_tween: Tween
var scale_tween: Tween

func _ready() -> void:
	# Espera o Godot terminar de calcular o layout e as âncoras da UI na tela
	await get_tree().process_frame
	
	# Define o pivô no centro
	pivot_offset = size / 2.0
	
	# Agora a posição Y salva será a correta (canto inferior)
	base_y = position.y
	
	start_float_animation()
	
	# Conecta os sinais
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	pressed.connect(_on_pressed)

func start_float_animation() -> void:
	# Cria um tween em loop infinito com suavização (Sine)
	float_tween = create_tween().set_loops().set_trans(Tween.TRANS_SINE)
	
	# Anima subindo e depois descendo de volta à posição base
	float_tween.tween_property(self, "position:y", base_y - float_distance, float_duration)
	float_tween.tween_property(self, "position:y", base_y, float_duration)

func _on_mouse_entered() -> void:
	# Cancela a animação de escala anterior para evitar conflitos visuais
	if scale_tween and scale_tween.is_valid():
		scale_tween.kill()
		
	scale_tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	scale_tween.tween_property(self, "scale", hover_scale, scale_duration)

func _on_mouse_exited() -> void:
	if scale_tween and scale_tween.is_valid():
		scale_tween.kill()
		
	scale_tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	scale_tween.tween_property(self, "scale", Vector2.ONE, scale_duration)

func _on_pressed() -> void:
	OS.shell_open("https://www.instagram.com/funaxys/")
