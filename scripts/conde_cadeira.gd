extends AnimatedSprite2D

@export var playing = false
var hasFinished = false
func _process(delta: float) -> void:
	if playing and !hasFinished:
		play("conde_cadeira")
		hasFinished = true
	else:
		if is_playing():
			play("default")
	if frame == 5:
		$"../conde_chair".play()

func _on_animation_finished() -> void:
	hasFinished = true
