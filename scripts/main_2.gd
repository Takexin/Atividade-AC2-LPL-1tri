extends Node2D

@onready var dialoguePath = load("res://assets/dialogue/main2.dialogue")
func _ready() -> void:
	$AnimationPlayer.play( "start_anim")
	#DialogueManager.show_dialogue_balloon(dialoguePath, "start")
