extends CharacterBody2D


var SPEED = 300.0
const ACCEL = 40
const JUMP_VELOCITY = -400.0
var canWalk = false
var canAttack = false

var madeiras = 0
var score = 0

signal incorrectAmmount

@export var scoreNeeded = 150

@onready var walkSound = $"../walk"
@onready var axeSound = $"../axe"
@onready var scoreSound = $"../getScore"
@onready var depositSound = $"../deposit"
@onready var wrongSound = $"../incorrect"

@onready var label = get_tree().root.get_node("core/main/CanvasLayer/Control/Label")
@onready var label2 = get_tree().root.get_node("core/main/CanvasLayer/Control/Label2")
@onready var fade = get_tree().root.get_node("core/main/CanvasLayer/fade")
@onready var dialogue = load("res://assets/dialogue/main.dialogue")
@onready var attackArea = $CollisionShape2D/Sprite2D/attackArea
@onready var rayCast = $CollisionShape2D/Sprite2D/RayCast2D
@onready var isMain = get_tree().root.get_node("core/main")
func animacao_texto():
	var subtexto

func _ready() -> void:
	
	if isMain:
		DialogueManager.show_dialogue_balloon(dialogue, "start")
		DialogueManager.connect("dialogue_ended", onDialogueEnded)
		var animationPlayer = get_tree().root.get_node("core/main/AnimationPlayer")
		animationPlayer.connect("animation_finished", onAnimationEnded)
	else:
		canWalk = true
		canAttack = true
		$Camera2D.enabled = true
var hasRun = false
func onDialogueEnded(resource):
	if !hasRun:
		hasRun = true
		if fade:
			fade.fadeTrigger = true
			await get_tree().create_timer(1).timeout
			DialogueManager.show_dialogue_balloon(dialogue, "comeco")
	else:
		if fade:
			get_tree().root.get_node("core/main/AnimationPlayer").play("start")

func onAnimationEnded(name):
	$Camera2D.enabled = true
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
		label.text = "Madeiras %s"%madeiras
		label2.text = "Dinheiro %s"%score
	if rayCast.is_colliding():
		var body = rayCast.get_collider()
		if body:
			if body.is_in_group("tree"):
				#$CollisionShape2D/Sprite2D/Mouse.set_deferred("global_position", body.global_position)
				$CollisionShape2D/Sprite2D/Mouse.global_position.x = body.global_position.x
				$CollisionShape2D/Sprite2D/Mouse.visible = true
				$AnimationPlayer.play("mouse click")
	else:
		$CollisionShape2D/Sprite2D/Mouse.visible = false
	
func _physics_process(delta: float) -> void: #fisica do spr
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("actionLeft", "actionRight")
	if direction and canWalk:
		if direction < 0:
			$CollisionShape2D/Sprite2D/Mouse.scale.x = abs($CollisionShape2D/Sprite2D/Mouse.scale.x) * -1
		else:
			$CollisionShape2D/Sprite2D/Mouse.scale.x = abs($CollisionShape2D/Sprite2D/Mouse.scale.x) 
		velocity.x = move_toward(velocity.x, direction * SPEED, ACCEL)
		if scoreNeeded == 0:
			if SPEED > 0:
				SPEED -= 1
		if !walkSound.playing and isMain:
			walkSound.play()
		$CollisionShape2D/Sprite2D.scale.x = abs($CollisionShape2D/Sprite2D.scale.x) * direction
	else:
		velocity.x = move_toward(velocity.x, 0, ACCEL)

	move_and_slide()
	


func _on_attack_area_area_entered(area: Area2D) -> void:
	if(area.is_in_group("tree")):
		canAttack = false
		attackArea.monitoring = true
		area.takeDamage()
		if !axeSound.playing && area.HITS < 5:
			axeSound.play()
		madeiras+=1
		attackArea.set_deferred("monitoring", false)
		await get_tree().create_timer(1).timeout
		canAttack = true

func _on_attack_area_body_entered(body: Node2D) -> void:
	attackArea.set_deferred("monitoring", false)
	if body.is_in_group("table"):
		if (madeiras >= 3):
			scoreSound.play(2)
			madeiras -=3
			score+= randi_range(23,33)
		else:
			wrongSound.play()
			incorrectAmmount.emit(1)
	if body.is_in_group("deposit"):
		if score == 0:
			wrongSound.play()
			incorrectAmmount.emit(2)  
		else:
			scoreNeeded -= score
			if score > 0 and scoreNeeded > 0:
				depositSound.play(1)
			score = 0
			if scoreNeeded <0:
				wrongSound.play()
				score = abs(scoreNeeded)
				scoreNeeded=0
