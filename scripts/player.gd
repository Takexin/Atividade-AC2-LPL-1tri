extends CharacterBody2D


const SPEED = 300.0
const ACCEL = 40
const JUMP_VELOCITY = -400.0
var canAttack = true

var madeiras = 0
var score = 0

var dialogo = [
	"Era uma vez...",
	"Alguma coisa aconteceu"
]
@onready var label = get_tree().root.get_node("main/CanvasLayer/Control/Label")
@onready var label2 = get_tree().root.get_node("main/CanvasLayer/Control/Label2")
@onready var attackArea = $CollisionShape2D/Sprite2D/attackArea
func animacao_texto():
	var subtexto

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
	label.text = "Madeiras %s"%madeiras
	label2.text = "Dinheiro %s"%score
	
func _physics_process(delta: float) -> void: #fisica do spr
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("actionJump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("actionLeft", "actionRight")
	if direction:
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
