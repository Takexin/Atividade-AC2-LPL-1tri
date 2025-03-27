extends Sprite2D
@export var fadeTrigger = false
var fadeValue : float = 0.0
func _ready() -> void:
	visible = true
func _process(delta: float) -> void:
	if fadeTrigger:
		self_modulate.a = move_toward(self_modulate.a, fadeValue, 0.01)
