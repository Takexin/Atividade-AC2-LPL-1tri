extends Sprite2D
@export var fadeTrigger = false
func _ready() -> void:
	visible = true
func _process(delta: float) -> void:
	if fadeTrigger:
		self_modulate.a = move_toward(self_modulate.a, 0, 0.01)
