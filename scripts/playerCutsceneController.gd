extends CharacterBody2D
@onready var animation = $AnimationPlayer

@export_enum("isWalking", "isIdle") var currentState : int

func _process(delta: float) -> void:
	if currentState == 0:
		animation.play("walk_luis")
	elif currentState == 1:
		animation.play("idle_luis")
		
		
func _physics_process(delta: float) -> void:
	move_and_slide()
