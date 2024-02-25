extends Node2D

var infrog
func _on_area_2d_2_area_entered(area):
	if area.is_in_group("frogs"):
		print('decas')

func _on_area_2d_2_area_exited(area):
	if area in get_tree().get_nodes_in_group("frogs"):
		print('ex')
