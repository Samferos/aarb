extends Area

export var weaponDamage : int

func enemyHit(body):
	if body.is_in_group("enemies"):
		body.receiveDamage(weaponDamage + get_node("../..").get_parent().status.get("ATK"), get_node("../..").get_parent())
