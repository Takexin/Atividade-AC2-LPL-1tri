extends CharacterBody2D

@export var SPEED = 230
@export var returnPos : float
const ACCEL = 40
var direction : float
var isAttacking = false
var HEALTH = 100

@onready var sprite = $AnimatedSprite2D 
@onready var animationPlayer = $AnimationPlayer
@onready var rayCast = $AnimatedSprite2D/RayCast2D


var player : Node2D
var canIdle : bool = false
var canWalk : bool = false
func _ready() -> void:
	returnPos = position.x
	canIdle = true
	canWalk = true
	player = get_parent().get_node("BrasPlayer")


func _process(delta: float) -> void:
	if rayCast.is_colliding():
		var body = rayCast.get_collider()
		if body.is_in_group("player") and !isAttacking:
			canIdle = false
			canWalk = false
			animationPlayer.play("attack_lobo")
			await animationPlayer.animation_finished
			
			canWalk = true
			isAttacking = true
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	if isAttacking:
		if returnPos - position.x >= 30:
			direction = returnPos - position.x
			if direction > 0: direction = 1
			elif direction < 0: direction = -1
			else: direction = 0
		else:
			isAttacking = false
	if player and !isAttacking:
		direction =  player.position.x - position.x 
		if direction > 0: direction = 1
		elif direction < 0: direction = -1
		else: direction = 0
	
	if direction and canWalk:
		sprite.play("run_lobo")
		velocity.x = move_toward(velocity.x, direction * SPEED, ACCEL)
		if !isAttacking:
			sprite.scale.x = abs(sprite.scale.x) * direction
	else:
		velocity.x = move_toward(velocity.x, 0, ACCEL)
		if canIdle:
			sprite.play("idle_lobo")

	move_and_slide()


func _on_hitbox_body_entered(body: Node2D) -> void:
	print("hit %s" %body.name)
	if body.is_in_group("player"):
		print("found player")
		body.takeDamage(self)
func takeDamage():
	HEALTH -= 10
	queue_free()
