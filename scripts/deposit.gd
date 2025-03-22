extends Node2D

var capturedPlayer = false
@onready var depositLabel = $Control/Dialogue/Label
@onready var player = get_parent().get_node("Player/CharacterBody2D")
func _process(delta: float) -> void:
	depositLabel.text = str(player.scoreNeeded)
	if capturedPlayer:
		$Control/Dialogue.scale.x = move_toward($Control/Dialogue.scale.x, 1, 0.1)
		$Control/Dialogue.scale.y = move_toward($Control/Dialogue.scale.y, 1, 0.1)
	else:
		$Control/Dialogue.scale.x = move_toward($Control/Dialogue.scale.x, 0, 0.1)
		$Control/Dialogue.scale.y = move_toward($Control/Dialogue.scale.y, 0, 0.1)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if(body.is_in_group("player")):
		capturedPlayer = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	capturedPlayer = false
