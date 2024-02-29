extends Node2D

var tree_sprites = {
	0: preload("res://Art Assets/Tree1.png"),
	1: preload("res://Art Assets/Tree2.png"),
	2: preload("res://Art Assets/Tree3.png")
}

@onready var tree = $Sprite2D

func _process(_delta):
	if GlobalScript.day >= 4:
		tree.texture = tree_sprites[2]
		$TreeLeavesSprite2D.visible = true
	elif GlobalScript.day >= 2:
		tree.texture = tree_sprites[1]
	else:
		tree.texture = tree_sprites[0]
