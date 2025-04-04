extends Node2D

@onready var animationPlayer = $AnimationPlayer
@onready var bopAnimation = $Camera2D/AnimationPlayer
@onready var fade =  $CanvasLayer/fade
@onready var music = $music
@onready var loboSprite = $foreground/lobo
@onready var playerSprite = $brasCutscene

@onready var player = $BrasPlayer
@onready var lobo = $Lobo
const dialogue3 = preload("res://assets/dialogue/main3.dialogue")
var dialogueBubble

func sceneEnd():
	lobo.call_deferred("queue_free")
	player.call_deferred("queue_free")
	music.stop()
	animationPlayer.play("fade")
	bopAnimation.play("RESET")
	await animationPlayer.animation_finished
	await get_tree().create_timer(2).timeout
	animationPlayer.play("end")
	await animationPlayer.animation_finished
	DialogueManager.show_dialogue_balloon(dialogue3, "final")
	await DialogueManager.dialogue_ended
	if get_parent():
		get_parent().swapScene(null,4)
func _ready():
	lobo.connect("hasDied", sceneEnd)
	fade.visible = true
	animationPlayer.play("chapter")
	await animationPlayer.animation_finished
	dialogueBubble = DialogueManager.show_dialogue_balloon(dialogue3, "start")
	dialogueBubble.skip_action = ""
	music.play()
	dialogueBubble.canSkip = false
	await dialogueBubble.lineEnded
	await get_tree().create_timer(1).timeout
	dialogueBubble.skipNext()
	await dialogueBubble.lineEnded
	animationPlayer.play("start1")
	await get_tree().create_timer(1).timeout
	dialogueBubble.skipNext()
	animationPlayer.play("start2")
	await dialogueBubble.lineEnded
	await get_tree().create_timer(1).timeout
	dialogueBubble.skipNext()
	await dialogueBubble.lineEnded
	await get_tree().create_timer(1).timeout
	dialogueBubble.skipNext()
	animationPlayer.play("start1")
	await dialogueBubble.lineEnded
	await get_tree().create_timer(1).timeout
	dialogueBubble.skipNext()
	await dialogueBubble.lineEnded
	dialogueBubble.skipNext()
	animationPlayer.play("start2")
	await dialogueBubble.lineEnded
	await get_tree().create_timer(1).timeout
	dialogueBubble.skipNext()
	await dialogueBubble.lineEnded
	await get_tree().create_timer(1).timeout
	dialogueBubble.skipNext()
	animationPlayer.play("start1")
	await dialogueBubble.lineEnded
	animationPlayer.play("end_start")
	await animationPlayer.animation_finished
	dialogueBubble.skipNext()
	bopAnimation.play("camera_bop")
	loboSprite.queue_free()
	playerSprite.queue_free()
	player.visible = true
	lobo.visible = true
	lobo.scale.x = abs(lobo.scale.x)
	player.process_mode = Node.PROCESS_MODE_INHERIT
	player.get_child(3).visible = true
	lobo.process_mode = Node.PROCESS_MODE_INHERIT
	
