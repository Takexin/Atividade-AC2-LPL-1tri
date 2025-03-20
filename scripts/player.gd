extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var score = 0
var dialogo = [
	"Era uma vez...",
	"Alguma coisa aconteceu"
]
@onready var label = get_tree().root.get_node("main/CanvasLayer/Control/Label")

func animacao_texto():
	var subtexto

func _ready() -> void:
	
	label.text = "smt"
	
func _process(delta: float) -> void:
	score+=1


func _physics_process(delta: float) -> void: #fisica do spr
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("actionJump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		$CollisionShape2D/Sprite2D.scale.x = abs($CollisionShape2D/Sprite2D.scale.x) * direction
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
