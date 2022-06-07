extends Node
onready var HUD = get_node("../HUD")
var enemiesCount := 0

func _enter_tree():
	yield(get_tree().create_timer(3), "timeout")
	HUD.get_node("AnimationPlayer").play("GUIHide")

func UpdateStatus(caller : Node):
	if caller.name == "Blue":
		HUD.get_node("BlueStats/HP").max_value = caller.status.HP
		HUD.get_node("BlueStats/HP").value = caller.currentHP
		HUD.get_node("BlueStats/LV").text = String(caller.status.LV)
	elif caller.name == "Red":
		HUD.get_node("RedStats/HP").max_value = caller.status.HP
		HUD.get_node("RedStats/HP").value = caller.currentHP
		HUD.get_node("RedStats/LV").text = String(caller.status.LV)

func BattleStart():
	print("BattleStarted")
	enemiesCount += 1
	if enemiesCount <= 0:
		HUD.get_node("AnimationPlayer").play_backwards("GUIHide")

func BattleEnd():
	print("BattleEnded")
	enemiesCount -= 1
	if enemiesCount <= 0:
		HUD.get_node("AnimationPlayer")
		HUD.get_node("AnimationPlayer").play("GUIHide")
