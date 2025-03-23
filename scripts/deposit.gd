extends Node2D

var capturedPlayer = false
@onready var depositLabel = $Control/Dialogue/Label
@onready var player = get_tree().root.get_node("core/main/Player/CharacterBody2D")
var incorrected = false

func _ready() -> void:
	player.call_deferred("connect", "incorrectAmmount", onIncorrectAmmount)
func onIncorrectAmmount(index):
	if index == 2:
		incorrected = true
		for i in 2:
			depositLabel.text = "[color=red]%s[/color] / " %player.score +  str(player.scoreNeeded)
			await get_tree().create_timer(0.1).timeout
			depositLabel.text ="%s / " %player.score +  str(player.scoreNeeded)
			await get_tree().create_timer(0.1).timeout
		incorrected = false
func _process(delta: float) -> void:
	if !incorrected:
		depositLabel.text ="%s / " %player.score +  str(player.scoreNeeded)
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
func _on_area_2d_area_entered(area: Area2D) -> void:
	if(area.is_in_group("player")):
		capturedPlayer = true


func _on_area_2d_area_exited(area: Area2D) -> void:
	if(area.is_in_group("player")):
		capturedPlayer = false
