extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D
@onready var animationPlayer = $AnimationPlayer
@export var HEALTH = 100
@export var SPEED = 300.0
@onready var strongHitBar = $CanvasLayer/Control/ProgressBar
@onready var timer = $Timer
const ACCEL = 40

@onready var airSound = $hitsound
@onready var hitSound = $hitland
#booleans
var canWalk : bool = false
var canIdle : bool = false
var tookDamage : bool = false

var damagePos : float
var direction : int
var hitBarValue : int = 0

func _ready() -> void:
	canWalk = true
	canIdle = true
func _process(delta: float) -> void:
	strongHitBar.value = hitBarValue
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("actionAttack") and !tookDamage:
		canWalk = false
		canIdle = false
		if hitBarValue != 40:
			if !animationPlayer.is_playing():
				animationPlayer.play("weak_attack_bras")
				airSound.play()
				timer.start(0.5)
		else:
			if !animationPlayer.is_playing():
				airSound.play()
				animationPlayer.play("strong_attack_bras")
				timer.start(1)
				hitBarValue = 0
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if !tookDamage:
		direction = Input.get_axis("actionLeft", "actionRight")
	else:
		if position.x <= 10 + damagePos:
			direction = 0
	if direction and canWalk:
		velocity.x = move_toward(velocity.x, direction * SPEED, ACCEL)
		if !tookDamage:
			sprite.play("run_bras")
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
	canWalk = false
	canIdle = false
	HEALTH -= ammount
	direction = caller.position.x - position.x
	if direction > 0 : direction = -1
	else: direction = 1
	damagePos = position.x + 30 * direction
	animationPlayer.stop()
	sprite.play("damage_bras")
	await sprite.animation_finished
	tookDamage = false
	canWalk = true
	canIdle = true
	direction = 0
	


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		if !body.sprite.is_playing():
			hitSound.play()
			if hitBarValue >= 40:
				body.takeDamage(30)
			if hitBarValue < 40:
				body.takeDamage(10)
				hitBarValue += 10


func _on_timer_timeout() -> void:
	canWalk = true
	canIdle = true
	tookDamage = false
