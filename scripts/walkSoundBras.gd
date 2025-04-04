extends AudioStreamPlayer

@export var timeDelay : float = 0.0
@onready var character = get_parent()


var canPlay = true

#handle Walk play sound controller

func _ready() -> void:
	timeDelay = 0.2
	volume_db = 10
	stream = load("res://assets/audio/minigame 2/player_walk_scene2.tres")

func _process(delta: float) -> void:
	if character.direction != 0 and !is_playing() and canPlay and character.canWalk:
		play()
		canPlay = false
		await get_tree().create_timer(timeDelay).timeout
		canPlay = true
