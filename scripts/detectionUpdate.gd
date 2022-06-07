extends RayCast
signal playerFound
var target : Spatial
var raycastLength : float

func _process(delta):
	var targetPosition : Vector3 = target.translation - get_parent().translation
	cast_to = targetPosition.normalized() * raycastLength

func _physics_process(delta):
	if is_colliding():
		if get_collider() == target:
			if get_collider().get_groups().has("players"):
				emit_signal("playerFound", get_collider())
