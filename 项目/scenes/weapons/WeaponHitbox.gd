extends Hitbox

func _on_area_entered(area:Area2D):
	area.queue_free()
