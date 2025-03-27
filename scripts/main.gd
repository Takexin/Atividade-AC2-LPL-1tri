extends Node2D
@onready var startCutscene = $AnimationPlayer
@onready var merchant = $Table
func _ready():
	startCutscene.connect("animation_finished", onCutsceneEnd)
	
func onCutsceneEnd(res):
	merchant.get_node("RigidBody2D/AnimatedSprite2D").play("table_idle")
	merchant.cutSceneEnded = true
	
