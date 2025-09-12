extends Area3D


@export var chunk : MeshInstance3D



func _on_area_entered(area: Area3D) -> void:
	print("body entered by ", area)
	if (area.is_in_group("Proximity")):
		chunk.visible = true;
		print("turning on")


func _on_area_exited(area: Area3D) -> void:
	print("body exited by ", area)
	if (area.is_in_group("Proximity")):
		chunk.visible = false
		print("turning off")
