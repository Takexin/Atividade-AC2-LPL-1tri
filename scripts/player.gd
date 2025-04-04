extends CharacterBody2D
#animação morte mano
#2 frame mais longo 170 ms
#ultimos 5 frames 2 seg
#resto 130ms

@export var SPEED = 300.0
const ACCEL = 40
const JUMP_VELOCITY = -400.0

var canIdle = true
var canWalk = false
var canAttack = false
var treeDead = false
var deadAnimationHasPlayed = false 
var currentCutscene = 0 #cutscene controller
var failedDialogue = false


@export var madeiras = 0
@export var score = 0
@export var scoreNeeded = 150
@export_enum("trisavo", "luis") var currentPlayer : int


signal incorrectAmmount
signal depositMax
signal hasDied
signal sceneFinished


#sound imports
@onready var walkSound = $"../walk"
@onready var axeSound = $"../axe"
@onready var scoreSound = $"../getScore"
@onready var depositSound = $"../deposit"
@onready var lastDepositSound = $"../last_deposit"
@onready var wrongSound = $"../incorrect"
@onready var droneSound = $"../drone"
@onready var heartSound = $"../heartbeat"
@onready var grassSound = $"../ambient_grass"
@onready var peopleSound = $"../ambient_people"


@onready var label = get_tree().root.get_node("core/main/CanvasLayer/Control/Label")
@onready var label2 = get_tree().root.get_node("core/main/CanvasLayer/Control/Label2")
@onready var fade = get_tree().root.get_node("core/main/CanvasLayer/fade")
@onready var dialogue = load("res://assets/dialogue/main.dialogue")
@onready var dialogue2 = load("res://assets/dialogue/main2.dialogue")
@onready var attackArea = $CollisionShape2D/Sprite2D/attackArea
@onready var rayCast = $CollisionShape2D/Sprite2D/RayCast2D


@onready var isMain = get_tree().root.get_node("core/main")
@onready var isMain2 = get_tree().root.get_node("core/main2")

@onready var currentMainScene = get_tree().root.get_child(3)
@onready var camera = $camera_scene1
@onready var mouseSprite = $"../CanvasLayer/Mouse"



var direction := Input.get_axis("actionLeft", "actionRight")
func _ready() -> void:
	print(currentMainScene.get_child(0).name)
	print(currentPlayer)
	if currentMainScene.name.to_lower() == "main" or currentMainScene.get_child(0).name == "main":
		var animationPlayer = get_tree().root.get_node("core/main/AnimationPlayer")
		animationPlayer.play("chapter")
		await animationPlayer.animation_finished
		grassSound.play()
		DialogueManager.show_dialogue_balloon(dialogue, "start")
		DialogueManager.connect("dialogue_ended", onDialogueEnded)
		
		animationPlayer.connect("animation_finished", onAnimationEnded)
		var startCamera = isMain.get_node("startCamera")
		camera.limit_left = startCamera.limit_left
		camera.limit_right = startCamera.limit_right
		
		
	elif currentMainScene.name.to_lower() == "main2" or currentMainScene.get_child(0).name.to_lower() == "main2":
		SPEED = 200
		DialogueManager.connect("dialogue_ended", onDialogue2Ended)
		canWalk = false
		canAttack = true
		camera.enabled = true
		#camera.limit_top = -105
		camera.limit_right = 3500
		camera.limit_left = 135
		#camera.limit_top = -105
		camera.limit_bottom = 540
		camera.zoom = Vector2(1.1,1.1)
	else:
		canWalk = true
		canAttack = true
		camera.enabled = true
		#grassSound.play()

func onDialogueEnded(resource):
	if isMain:
		if currentCutscene == 0:
			currentCutscene +=1
			if fade:
				fade.fadeTrigger = true
				await get_tree().create_timer(1).timeout
				DialogueManager.show_dialogue_balloon(dialogue, "comeco")
		elif currentCutscene == 1:
			if fade:
				get_tree().root.get_node("core/main/AnimationPlayer").play("start")
		elif currentCutscene ==2:
			await get_tree().create_timer(2).timeout
			sceneFinished.emit()
	
func onDialogue2Ended(res):
	print("dialogue ended")
	if Global.playerDialogueState == 1:
		canWalk = false
		canIdle = false
		canAttack = false
		$AnimationPlayer.play("dead_luis")
	elif Global.playerDialogueState ==2:
		canWalk = false
		canIdle = false
		canAttack = false
		if !deadAnimationHasPlayed:
			deadAnimationHasPlayed = true
			$AnimationPlayer.play("win_luis")
	else:
		canWalk = true


func onAnimationEnded(name):
	camera.enabled = true
	canWalk = true
	canAttack = true

func _unhandled_input(event: InputEvent) -> void:
	if (event.is_action_pressed("actionAttack") and canAttack):
		attackArea.set_deferred("monitoring", true)
		await get_tree().create_timer(1).timeout
		attackArea.set_deferred("monitoring", false)
		
	if(event.is_action_pressed("reset")):
		get_tree().reload_current_scene()
	
func _process(delta: float) -> void:
	if label:
		label.text = "%s"%madeiras
		label2.text = "%s"%score
	if rayCast.is_colliding():
		var body = rayCast.get_collider()
		if body:
			if (body.is_in_group("tree") or body.is_in_group("table") or body.is_in_group("deposit") or body.is_in_group("conde")) and treeDead == false and canWalk:
				#$CollisionShape2D/Sprite2D/Mouse.set_deferred("global_position", body.global_position)
				#$CollisionShape2D/Sprite2D/Mouse.global_position.x = body.global_position.x
				mouseSprite.visible = true
				$AnimationPlayer2.play("mouse click")
			else:
				mouseSprite.visible = false
	
	else:
		mouseSprite.visible = false
	
func _physics_process(delta: float) -> void: #fisica do spr
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	if SPEED <= 50:
		canWalk = false
		canIdle= false
		canAttack = false
		if !deadAnimationHasPlayed:
			deadAnimationHasPlayed = true
			$AnimationPlayer.call_deferred("play", "dead_trisavo")
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_axis("actionLeft", "actionRight")
	if direction and canWalk:
		if currentPlayer == 0:
			$AnimationPlayer.play("walk_trisavo")
		elif currentPlayer == 1:
			$AnimationPlayer.play("walk_luis")
		
		velocity.x = move_toward(velocity.x, direction * SPEED, ACCEL)
		
		if scoreNeeded == 0:
			if SPEED > 0:
				isMain.get_node("CanvasLayer/Control").visible = false
				treeDead = true
				SPEED -= 0.2
		$CollisionShape2D/Sprite2D.scale.x = abs($CollisionShape2D/Sprite2D.scale.x) * direction
	else:
		velocity.x = move_toward(velocity.x, 0, ACCEL)
		if canIdle:
			if currentPlayer == 0:
				$AnimationPlayer.play("idle_trisavo")
			elif currentPlayer == 1:
				$AnimationPlayer.play("idle_luis")

	move_and_slide()
	


func _on_attack_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("table"):
		if (madeiras >= 3):
			scoreSound.play(2)
			madeiras -=3
			score+= randi_range(23,33)
		else:
			wrongSound.play()
			incorrectAmmount.emit(1)
	if(area.is_in_group("tree")):
		var treeHits = area.HITS
		canAttack = false
		attackArea.monitoring = true
		canIdle=  false
		canWalk = false
		$AnimationPlayer.play("attack_trisavo")
		await get_tree().create_timer(0.25).timeout
		area.takeDamage()
		if !axeSound.playing and treeHits < 5:
			axeSound.play()
		else:
			treeDead = true
		madeiras+=1
		attackArea.set_deferred("monitoring", false)
		await get_tree().create_timer(0.5).timeout
		canAttack = true
		canWalk = true
		canIdle = true
		treeDead = false
func _on_attack_area_body_entered(body: Node2D) -> void:
	attackArea.set_deferred("monitoring", false)
	
	if body.is_in_group("deposit"):
		if score == 0:
			wrongSound.play()
			incorrectAmmount.emit(2)  
		else:
			scoreNeeded -= score
			if score > 0 and scoreNeeded > 0:
				depositSound.play(1)
			score = 0
			if scoreNeeded <=0:
				for child in get_parent().get_children():
					if child.is_class("AudioStreamPlayer") and !(child.name == droneSound.name or child.name == heartSound.name):
						child.bus = "Scene 1"
				lastDepositSound.play()
				if !droneSound.playing:
					droneSound.play()
					heartSound.play()
				SPEED = 150
				score = abs(scoreNeeded)
				scoreNeeded=0
				body.get_parent().depositMax = true
				body.get_parent().onDepositMax()
				depositMax.emit()
	elif body.is_in_group("conde"):
		DialogueManager.show_dialogue_balloon(dialogue2, "start")
		canWalk = false


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "dead_trisavo":
		heartSound.playing = false
		grassSound.playing = false
		hasDied.emit()
		await get_tree().create_timer(3).timeout
		DialogueManager.show_dialogue_balloon(dialogue, "morte")
		currentCutscene = 2
	elif anim_name == "dead_luis":
		get_parent().get_parent().get_node("CanvasLayer/Control").visible = true
	elif anim_name == "win_luis":
		var controlNode = get_parent().get_parent().get_node("CanvasLayer/Control")
		controlNode.get_child(1).text = "Você ganhou o respeito do Conde"
		controlNode.get_child(0).queue_free()
		controlNode.visible = true
		sceneFinished.emit()
		
