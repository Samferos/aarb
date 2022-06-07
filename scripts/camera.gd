extends Camera
onready var players = get_tree().get_nodes_in_group("players")
export var offset : Vector3

func _process(delta):
	translation = ObtainMidpoint(players) + offset
	fov = clamp(fov,70, 110)

func ObtainMidpoint(targets:Array) -> Vector3:
	var result : Vector3
	for i in targets:
		result.x += i.translation.x
	result.x = result.x / targets.size()
	for i in targets:
		result.y += i.translation.y
	result.y = result.y / targets.size()
	for i in targets:
		result.z += i.translation.z
	result.z = result.z / targets.size()
	return result

func ObtainBoundaries(targets:Array) -> Vector2:
	var boundaries = Vector2.ZERO
	for i in targets:
		if targets[i].translation.x < boundaries.x:
			boundaries.x = targets[i].translation.x
		if targets[i].translation.x > boundaries.y:
			boundaries.y = targets[i].translation.x
	return boundaries
