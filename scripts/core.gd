extends Node2D

@onready var currentScene = get_child(0)
@onready var scene2 = preload("res://scenes/minigame 2/main2.tscn")
func _ready() -> void:
	if currentScene.name == "main":
		var player = currentScene.get_node("Player/CharacterBody2D")
		player.call_deferred("connect", "sceneFinished", onFirstSceneFinished)
		
func onFirstSceneFinished():
	swapScene(scene2)
func swapScene(scene) -> void:
	currentScene.queue_free()
	var sceneInstance = scene.instantiate()
	await currentScene.tree_exited
	call_deferred("add_child", sceneInstance)
	currentScene = sceneInstance
