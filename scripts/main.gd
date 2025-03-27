extends Node2D
@onready var startCutscene = $AnimationPlayer
@onready var merchant = $Table
@onready var player = $Player/CharacterBody2D
@onready var treeSpanwer = $treeGround
@onready var fadeSprite = $CanvasLayer/fade
func _ready():
	startCutscene.connect("animation_finished", onCutsceneEnd)
	player.connect("depositMax", onDepositMax)
	player.connect("hasDied", onPlayerDead)
	
func onDepositMax():
		treeSpanwer.TREE_LIMIT = 0
func onPlayerDead():
	print("player died")
	fadeSprite.fadeValue = 1.0
	
	
func onCutsceneEnd(res):
	merchant.get_node("RigidBody2D/AnimatedSprite2D").play("table_idle")
	merchant.cutSceneEnded = true
	
