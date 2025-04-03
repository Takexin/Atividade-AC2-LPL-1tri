extends Node2D

@onready var animationPlayer = $AnimationPlayer
@onready var fade =  $CanvasLayer/fade




func _ready():
	fade.visible = false
