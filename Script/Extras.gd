extends Node2D

func _ready():
	$Extras1.visible = false
	$Extras2.visible = false
	$Extras3.visible = false

func _process(_delta):
	if GlobalScript.money > 250:
		$Extras3.visible = true
	if GlobalScript.money > 500:
		$Extras2.visible = true
	if GlobalScript.money > 800:
		$Extras1.visible = true
