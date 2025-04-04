extends Node2D

@onready var currentScene = get_child(0)
const scene2 = preload("res://scenes/minigame 2/main2.tscn")
const scene3 = preload("res://scenes/minigame 3/main 3.tscn")
const scene4 = preload("res://scenes/minigame 4/main 4.tscn")

func _ready() -> void:
	if currentScene.name == "main":
		var player = currentScene.get_node("Player/CharacterBody2D")
		player.call_deferred("connect", "sceneFinished", onFirstSceneFinished)
		
func onFirstSceneFinished():
	swapScene(scene2)
func swapScene(scene, sceneIndex = -1) -> void:
	if sceneIndex == -1:
		currentScene.queue_free()
		var sceneInstance = scene.instantiate()
		await currentScene.tree_exited
		add_child(sceneInstance)
		currentScene = sceneInstance
		await sceneInstance.ready
	else:
		if sceneIndex == 2:
			currentScene.queue_free()
			var sceneInstance = scene2.instantiate()
			await currentScene.tree_exited
			add_child(sceneInstance)
			currentScene = sceneInstance
			await sceneInstance.ready
		if sceneIndex == 3:
			currentScene.queue_free()
			var sceneInstance = scene3.instantiate()
			await currentScene.tree_exited
			add_child(sceneInstance)
			currentScene = sceneInstance
			await sceneInstance.ready
		if sceneIndex == 4:
			currentScene.queue_free()
			var sceneInstance = scene4.instantiate()
			await currentScene.tree_exited
			add_child(sceneInstance)
			currentScene = sceneInstance
			await sceneInstance.ready
