extends CharacterBody2D

@export var SPEED = 230
@export var returnPos : float
const ACCEL = 40
var direction : float
var isAttacking = false
var HEALTH = 140

@onready var timer = $attackCooldown
@onready var sprite = $AnimatedSprite2D 
@onready var animationPlayer = $AnimationPlayer
@onready var rayCast = $AnimatedSprite2D/RayCast2D
@onready var airSound = $hitsound
@onready var hitSound = $hitland
signal hasDied

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
			isAttacking = true
			canIdle = false
			canWalk = false
			animationPlayer.play("attack_lobo")
			timer.start(2)
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
		
		velocity.x = move_toward(velocity.x, direction * SPEED, ACCEL)
		if !isAttacking:
			sprite.play("run_lobo")
			sprite.scale.x = abs(sprite.scale.x) * direction
		else:
			sprite.play("backwalk_lobo")
	else:
		velocity.x = move_toward(velocity.x, 0, ACCEL)
		if canIdle:
			sprite.play("idle_lobo")

	move_and_slide()

var canHit = true
func _on_hitbox_body_entered(body: Node2D) -> void:
	print("hit %s" %body.name)
	if body.is_in_group("player"):
		print("found player")
		hitSound.play()
		body.takeDamage(self)
func takeDamage(ammount):
	if canHit:
		animationPlayer.stop()
		canHit = true
		direction = 0
		HEALTH -= 10
		canWalk = false
		canIdle = false
		sprite.play("damaged_lobo")
		await sprite.animation_finished
		canHit = true
		canWalk = false
		canIdle = false
		if HEALTH <= 0:
			hasDied.emit()


func _on_attack_cooldown_timeout() -> void:
	canWalk = true
