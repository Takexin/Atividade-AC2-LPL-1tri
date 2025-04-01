extends Node2D
#controller for player animations - cutscenes
#this controller assumes that the character is currently in a cutscene
@onready var character = $CharacterBody2D
@onready var animation = $CharacterBody2D/AnimationPlayer

@export var isWalking = false
@export var isIdle = false
var isControlling = false
func _process(delta: float) -> void:
	if isWalking or isIdle:
		character.canIdle = false
		character.canAttack = false
		character.canWalk = false
		if isWalking:
			animation.play("walk_trisavo")
		elif isIdle:
			animation.play("idle_trisavo")
	else:
		character.canIdle = true
		character.canAttack = true
		character.canWalk = true
		
