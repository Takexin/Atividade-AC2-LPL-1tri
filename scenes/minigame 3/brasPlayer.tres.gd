extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D
@onready var animationPlayer = $AnimationPlayer
@export var HEALTH = 100
@export var SPEED = 300.0
const ACCEL = 40

#booleans
var canWalk : bool = false
var canIdle : bool = false
var tookDamage : bool = false
var damagePos : float
var direction : int

func _ready() -> void:
	canWalk = true
	canIdle = true

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("actionAttack"):
		canWalk = false
		canIdle = false
		animationPlayer.play("weak_attack_bras")
		await animationPlayer.animation_finished
		canWalk = true
		canIdle = true
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if !tookDamage:
		direction = Input.get_axis("actionLeft", "actionRight")
	else:
		if position.x <= 10 + damagePos:
			direction = -direction
			tookDamage = false
			canWalk = true
			canIdle = true
	if direction and canWalk:		
		if !tookDamage:
			sprite.play("run_bras")
		velocity.x = move_toward(velocity.x, direction * SPEED, ACCEL)
		if !tookDamage:
			sprite.scale.x = abs(sprite.scale.x) * direction
		else:
			sprite.scale.x = abs(sprite.scale.x) * -direction
	else:
		velocity.x = move_toward(velocity.x, 0, ACCEL)
		if canIdle:
			sprite.play("idle_bras")

	move_and_slide()

func takeDamage(caller : Node2D, ammount = 10):
	tookDamage = true
	HEALTH -= ammount
	direction = caller.position.x - position.x
	if direction > 0 : direction = -1
	else: direction = 1
	damagePos = position.x + 30 * direction
	


func _on_hitbox_body_entered(body: Node2D) -> void:
	print("hit %s" %body.name)
	if body.is_in_group("enemy"):
		body.takeDamage()
