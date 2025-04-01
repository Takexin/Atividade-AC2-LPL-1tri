extends Node2D

@onready var dialoguePath = load("res://assets/dialogue/main2.dialogue")
@onready var playerScene = load("res://scenes/player.tscn")
@onready var cutscenePlayer = $CharacterBody2D
@onready var cutsceneCamera = $cutsceneCamera
func _ready() -> void:
	$AnimationPlayer.play( "start_anim")
	#DialogueManager.show_dialogue_balloon(dialoguePath, "start")
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("reset"):
		get_tree().reload_current_scene()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	var playerInstance = playerScene.instantiate()
	playerInstance.global_position = cutscenePlayer.global_position
	cutscenePlayer.queue_free()
	print(cutscenePlayer.position)
	playerInstance.get_child(0).currentPlayer = 1
	cutsceneCamera.enabled = false
	add_child(playerInstance)
	
	
