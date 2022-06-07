extends AnimatedSprite3D
var lvUP = "res://assets/sounds/Fx/LVUPSFX.mp3"

func playFX(index : int):
	visible = true
	frame = 0
	if index == 0:
		$SFX.stream = load(lvUP)
		$SFX.play(0)
		play("LevelUP")

func FXOver():
	visible = false
