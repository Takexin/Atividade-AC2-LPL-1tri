extends Node2D

@onready var fade = $fade
const dialogue = preload("res://assets/dialogue/main4.dialogue")

func _ready() -> void:
	$foreground/tainah.visible = true
	$background/AnimatedSprite2D.visible = true
	$background/AnimatedSprite2D.scale = Vector2(6.899,9.646)
	fade.fadeTrigger = true
	DialogueManager.show_dialogue_balloon(dialogue, "start")
	$music.play(3)
	await DialogueManager.dialogue_ended
	fade.fadeValue = 1
	await get_tree().create_timer(2).timeout
	$background/AnimatedSprite2D.scale = Vector2(2.919,3.307)
	$background/AnimatedSprite2D.play("back3")
	$foreground/tainah.queue_free()
	fade.fadeValue = 0.5
	$CanvasLayer.visible = true
	
