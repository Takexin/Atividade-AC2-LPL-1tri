extends Node2D

const dialoguePath = preload("res://assets/dialogue/main2.dialogue")
const playerScene = preload("res://scenes/player.tscn")
@onready var cutscenePlayer = $CharacterBody2D
@onready var cutsceneCamera = $cutsceneCamera
@onready var condeCadeira = $conde_cadeira


func _ready() -> void:
	await get_tree().create_timer(1).timeout
	$AnimationPlayer.play( "start_anim")
	#DialogueManager.show_dialogue_balloon(dialoguePath, "start")
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("reset"):
		get_tree().reload_current_scene()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "start_anim":
		var playerInstance = playerScene.instantiate()
		playerInstance.global_position = cutscenePlayer.global_position
		cutscenePlayer.queue_free()
		condeCadeira.queue_free()
		playerInstance.get_child(0).currentPlayer = 1
		cutsceneCamera.enabled = false
		add_child(playerInstance)
		await playerInstance.ready
		
	
