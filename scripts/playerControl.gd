extends KinematicBody
export var playerID := 1
onready var gameManager = get_node("../GameManager")
var status := {"LV":1, "XP":0, "HP":10, "SP":25, "ATK":1, "DEF":1, "DEX":1}
var currentHP : int
var currentSP : int
var currentWeapon : String
var speed = 10
var fallingSpeed := -1.0
var direction := Vector3.ZERO
var fallingScale = 5
var lastDirection := Vector3.LEFT
var ctrlEnabled = true
var attacking = false
var sndHit = false
var comboReg = false

func _ready():
	yield(get_tree(), "idle_frame")
	currentHP = status.HP
	currentSP = status.SP
	currentWeapon = "ironSword"
	statusUpdate()

func _process(delta):
	move_and_slide(Vector3(0,fallingSpeed,0) * fallingScale * delta, Vector3.UP, false, 6, 45)
	if ctrlEnabled:
		if Input.is_action_just_pressed("action_Player" + String(playerID)):
			attack()
		if not attacking:
			direction = Vector3(int(Input.is_action_pressed("moveWest_Player" + String(playerID)))-int(Input.is_action_pressed("moveEast_Player" + String(playerID))),0,int(Input.is_action_pressed("moveNorth_Player" + String(playerID)))-int(Input.is_action_pressed("moveSouth_Player" + String(playerID))))
			direction = direction.normalized()
			move_and_collide(direction * speed * delta)
			if not direction == Vector3.ZERO:
				$Sprite.animation = "Moving"
				lastDirection = direction
			elif $Sprite.animation == "Moving":
				$Sprite.animation = "Idle"
			if lastDirection.x < 0 and $Sprite.flip_h == true:
				$Sprite.flip_h = false
			elif lastDirection.x > 0 and $Sprite.flip_h == false:
				$Sprite.flip_h = true
	if not is_on_floor():
		fallingSpeed -= 3
		fallingSpeed = clamp(fallingSpeed, -1000.0, 1000)
	else:
		fallingSpeed = -1
	if Input.is_action_just_pressed("cancel_Player" + String(playerID)):
		status.XP += int(pow(status.LV+sqrt(20),2))
		statusUpdate()
	if $Sprite.animation == "Moving" and $Sprite.frame == 6 and not $Footsteps.playing:
		$Footsteps.play()

func attack():
	$Weapon/Sword/HitArea.monitoring = true
	$Weapon.rotation.y = lastDirection.angle_to(Vector3.FORWARD) * sign(-lastDirection.x + 0.1)
	if not attacking:
		$AttackTimeout.start(0)
		comboReg = false
		attacking = true
		# Start animations depending on combo streak
		$Sprite.play("Attack" + String(int(sndHit) + 1))
		$Sprite.frame = 0
		$Weapon/AnimationPlayer.stop(true)
		$Weapon/Sword.get_surface_material(0).set("shader_param/Fade", 0.3)
		$Weapon/AnimationPlayer.play("Attack" + String(int(sndHit) + 1))
		$Weapon/Sword/fade.stop_all()
		$Weapon/Sword/swoosh.play()
		$Weapon.visible = true
		sndHit = not sndHit
	else:
		comboReg = true

func comboTimeout():
	attacking = false
	if comboReg:
		attack()
	else:
		sndHit = false
		$Weapon/Sword/fade.interpolate_property($Weapon/Sword.get_surface_material(0),"shader_param/Fade",0.3, -0.3, 0.7)
		$Weapon/Sword/fade.start()
		$Weapon/Sword/particles.restart()
		$Weapon/Sword/HitArea.monitoring = false
	print("Combo Timeout")

func animationFinished():
	if $Sprite.animation == "Attack1" or $Sprite.animation == "Attack2":
		$Sprite.animation = "Idle"

func statusUpdate():
	print(currentHP)
	if currentHP <= 0:
		ctrlEnabled = false
		$Sprite.animation = "Down"
	if status.XP >= int(pow(status.LV+sqrt(20),2)):
		status.XP = 0
		status.LV += 1
		status.HP = int(20+pow(status.LV,1.2)*5)
		currentHP = status.HP
		status.SP = int(5+2*pow(status.LV,1.0005))
		currentSP = status.SP
		$FX.playFX(0)
	gameManager.UpdateStatus(self)

func giveXP(amount):
	status.XP += amount
	statusUpdate()
