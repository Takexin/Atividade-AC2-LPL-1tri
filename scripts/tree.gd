extends Area2D
@export var HITS : int = 0
signal tree_died
@onready var treeBreakSound = $treeBreak


func takeDamage():
	var previousColor = $"../AnimatedSprite2D".self_modulate
	$"../AnimatedSprite2D".self_modulate = Color(255,255,255)
	await get_tree().create_timer(0.1).timeout
	$"../AnimatedSprite2D".self_modulate = previousColor	
	HITS +=1
	if (HITS >=6):
		treeBreakSound.play()
		get_parent().visible = false
		emit_signal("tree_died")
		
	


func _on_tree_break_finished() -> void:
	get_parent().call_deferred("queue_free")
