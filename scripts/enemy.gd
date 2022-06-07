extends KinematicBody
var enemyIndex
export var HP : int
export var givenXP : int
export var detectionRadius : float
export var speed = 4.0
var target : Spatial
var alertState := false
var detectionRaycasts : Array
var attacking = false

func _enter_tree():
	resetAlertState()

func _process(delta):
	if alertState and not attacking:
		move_and_collide(translation.direction_to(target.translation + Vector3.UP * 1.4) * speed * delta)
		if translation.distance_to(target.translation) <= 2:
			print("near enough for attack")
			Attack()

func receiveDamage(dmg, dealer):
	HP -= int(dmg)
	if HP <= 0:
		die()
	alertState(dealer)

func die():
	get_tree().call_group("players", "giveXP", givenXP/2)
	target.giveXP(givenXP/2)
	$Sprite.visible = false
	$defeatedParticles.emitting = true
	$poof.play()
	$Collision.disabled = true
	get_node("../GameManager").BattleEnd()
	yield(get_tree().create_timer(1), "timeout")
	queue_free()

func alertState(found):
	for i in detectionRaycasts.size():
		detectionRaycasts[i].queue_free()
	detectionRaycasts.clear()
	target = found
	if not alertState:
		get_node("../GameManager").BattleStart()
	alertState = true

func resetAlertState():
	for i in get_tree().get_nodes_in_group("players"):
		var raycast = load("res://objects/enemies/util/DetectionRaycast.tscn").instance()
		raycast.target = i
		raycast.raycastLength = detectionRadius
		raycast.connect("playerFound", self, "alertState")
		detectionRaycasts.append(raycast)
		add_child(raycast, true)

func Attack():
	print("LETS GOOOOO")
	attacking = true
	var pastPosition = translation
	$Tween.interpolate_property(self, "translation", translation, target.translation, 0.4)
	$Tween.interpolate_property(self, "translation", translation, pastPosition, 0.4)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	attacking = false
