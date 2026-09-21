extends Hitbox # Substitui o extends Area2D

@export var speed := 230.0
var direction := Vector2.ZERO

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _physics_process(delta: float) -> void:
	position += direction * speed * delta

func set_direction(new_direction: Vector2) -> void :
	direction = new_direction.normalized()
	rotation = direction.angle()

func _on_body_entered(_body: Node2D) -> void:
	queue_free()
