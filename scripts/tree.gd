extends Area2D
var HITS : int = 0

func takeDamage():
	var previousColor = $Sprite2D.self_modulate
	$Sprite2D.self_modulate = Color(255,255,255)
	HITS +=1
	if (HITS >=6):
		get_parent().call_deferred("queue_free")
	await get_tree().create_timer(0.1).timeout
	$Sprite2D.self_modulate = previousColor	
