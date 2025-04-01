extends AnimatedSprite2D

@export var playing = false
var hasFinished = false
func _process(delta: float) -> void:
	if playing and !hasFinished:
		play("conde_cadeira")
	else:
		if is_playing():
			play("default")


func _on_animation_finished() -> void:
	hasFinished = true
