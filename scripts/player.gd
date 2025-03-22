extends CharacterBody2D


const SPEED = 300.0
const ACCEL = 40
const JUMP_VELOCITY = -400.0
var canWalk = false
var canAttack = true

var madeiras = 0
var score = 0
@export var scoreNeeded = 150

@onready var label = get_tree().root.get_node("core/main/CanvasLayer/Control/Label")
@onready var label2 = get_tree().root.get_node("core/main/CanvasLayer/Control/Label2")
@onready var fade = get_tree().root.get_node("core/main/CanvasLayer/fade")
@onready var attackArea = $CollisionShape2D/Sprite2D/attackArea
func animacao_texto():
	var subtexto

func _ready() -> void:
	var dialogue = load("res://assets/dialogue/main.dialogue")
	DialogueManager.show_dialogue_balloon(dialogue, "start")
	DialogueManager.connect("dialogue_ended", onDialogueEnded)
	
func onDialogueEnded(resource):
	fade.fadeTrigger = true
	canWalk = true

func _unhandled_input(event: InputEvent) -> void:
	if (event.is_action_pressed("actionAttack") and canAttack):
		print("attacked")
		canAttack = false
		attackArea.monitoring = true
		await get_tree().create_timer(1).timeout
		canAttack = true
		attackArea.monitoring = false
	if(event.is_action_pressed("reset")):
		get_tree().reload_current_scene()
	
func _process(delta: float) -> void:
	label.text = "Madeiras ççççç %s"%madeiras
	label2.text = "Dinheiro %s"%score
	
func _physics_process(delta: float) -> void: #fisica do spr
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("actionLeft", "actionRight")
	if direction and canWalk:
		velocity.x = move_toward(velocity.x, direction * SPEED, ACCEL)
		$CollisionShape2D/Sprite2D.scale.x = abs($CollisionShape2D/Sprite2D.scale.x) * direction
	else:
		velocity.x = move_toward(velocity.x, 0, ACCEL)

	move_and_slide()
	


func _on_attack_area_area_entered(area: Area2D) -> void:
	if(area.is_in_group("tree")):
		area.takeDamage()
		madeiras+=1
		attackArea.set_deferred("monitoring", false)

func _on_attack_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("table"):
		if (madeiras >= 3):
			madeiras -=3
			score+= randi_range(23,33)
	if body.is_in_group("deposit"):
		scoreNeeded -= score
		score = 0
		if scoreNeeded <=0:
			scoreNeeded=0
