extends CharacterBody2D
@onready var animation = $AnimationPlayer
@export var isWalking = false
@export var isIdle = false

func _process(delta: float) -> void:
	if isWalking:
		animation.play("walk_trisavo")
	elif isIdle:
		animation.play("idle_trisavo")
		
		
func _physics_process(delta: float) -> void:
	move_and_slide()
