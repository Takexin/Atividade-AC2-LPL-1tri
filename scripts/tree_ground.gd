extends RigidBody2D
@onready var treeScene = preload("res://scenes/tree.tscn")
var TREE_LIMIT = 6
var currentTrees = 0
func spawnTree(res):
	print("spawning process")
	while(true):
		if(currentTrees < TREE_LIMIT):
			print("tree spawned")
			currentTrees+=1
			var treeInstance = treeScene.instantiate()
			treeInstance.position.y = $CollisionShape2D.position.y/2
			treeInstance.position.x = randi_range($CollisionShape2D.position.x - ($CollisionShape2D.shape.size.x*2),$CollisionShape2D.position.x + ($CollisionShape2D.shape.size.x*2))
			get_parent().call_deferred("add_child", treeInstance)
			treeInstance.get_child(0).call_deferred("connect", "tree_died", onTreeDeath)
			print(treeInstance.position)
			#treeInstance.position.x = randi_range()
		await get_tree().create_timer(20).timeout
func onTreeDeath():
	currentTrees -=1
func _ready() -> void:
	spawnTree(null)
	#get_tree().root.get_node("core/main/AnimationPlayer").connect("animation_finished", spawnTree)
