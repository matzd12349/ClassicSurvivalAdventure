extends AnimationTree

#define animation states
enum {IDLE, WALK, RUN, HURT, AIM, ATTACK, DEAD}

#animation variable to blend animations together
@export var blendSpeed: int = 5
#variables for the blend amounts for 
var walkVal: float = 0
var runVal: float = 0
var aimVal: float = 0
var hurtVal: float = 0
var atkVal: float = 0
var deadVal: float = 0

func AnimationChange(delta: float, curAnim: int) -> void:
	match curAnim:
		IDLE:
			walkVal = lerpf(walkVal, 0, blendSpeed * delta)
			runVal = lerpf(runVal, 0, blendSpeed * delta)
			aimVal = lerpf(aimVal, 0, blendSpeed * delta)
			hurtVal = lerpf(hurtVal, 0, blendSpeed * delta)
			atkVal = lerpf(atkVal, 0, blendSpeed * delta)
			deadVal = lerpf(deadVal, 0, blendSpeed * delta)
		WALK:
			walkVal = lerpf(walkVal, 1, blendSpeed * delta)
			runVal = lerpf(runVal, 0, blendSpeed * delta)
			aimVal = lerpf(aimVal, 0, blendSpeed * delta)
			hurtVal = lerpf(hurtVal, 0, blendSpeed * delta)
			atkVal = lerpf(atkVal, 0, blendSpeed * delta)
			deadVal = lerpf(deadVal, 0, blendSpeed * delta)
		RUN:
			walkVal = lerpf(walkVal, 0, blendSpeed * delta)
			runVal = lerpf(runVal, 1, blendSpeed * delta)
			aimVal = lerpf(aimVal, 0, blendSpeed * delta)
			hurtVal = lerpf(hurtVal, 0, blendSpeed * delta)
			atkVal = lerpf(atkVal, 0, blendSpeed * delta)
			deadVal = lerpf(deadVal, 0, blendSpeed * delta)
		HURT:
			walkVal = lerpf(walkVal, 0, blendSpeed * delta)
			runVal = lerpf(runVal, 0, blendSpeed * delta)
			aimVal = lerpf(aimVal, 0, blendSpeed * delta)
			hurtVal = lerpf(hurtVal, 1, blendSpeed * delta)
			atkVal = lerpf(atkVal, 0, blendSpeed * delta)
			deadVal = lerpf(deadVal, 0, blendSpeed * delta)
		AIM:
			walkVal = lerpf(walkVal, 0, blendSpeed * delta)
			runVal = lerpf(runVal, 0, blendSpeed * delta)
			aimVal = lerpf(aimVal, 1, blendSpeed * delta)
			hurtVal = lerpf(hurtVal, 0, blendSpeed * delta)
			atkVal = lerpf(atkVal, 0, blendSpeed * delta)
			deadVal = lerpf(deadVal, 0, blendSpeed * delta)
		ATTACK:
			walkVal = lerpf(walkVal, 0, blendSpeed * delta)
			runVal = lerpf(runVal, 0, blendSpeed * delta)
			aimVal = lerpf(aimVal, 0, blendSpeed * delta)
			hurtVal = lerpf(hurtVal, 0, blendSpeed * delta)
			atkVal = lerpf(atkVal, 1, blendSpeed * delta)
			deadVal = lerpf(deadVal, 0, blendSpeed * delta)
		DEAD:
			walkVal = lerpf(walkVal, 0, blendSpeed * delta)
			runVal = lerpf(runVal, 0, blendSpeed * delta)
			aimVal = lerpf(aimVal, 0, blendSpeed * delta)
			hurtVal = lerpf(hurtVal, 0, blendSpeed * delta)
			atkVal = lerpf(atkVal, 0, blendSpeed * delta)
			deadVal = lerpf(deadVal, 1, blendSpeed * delta)
	UpdateTree()

func UpdateTree() -> void:
	$"."["parameters/walk/blend_amount"] = walkVal
	$"."["parameters/run/blend_amount"] = runVal
	$"."["parameters/aim/blend_amount"] = aimVal
	$"."["parameters/hurt/blend_amount"] = hurtVal
	$"."["parameters/atk/blend_amount"] = atkVal
	$"."["parameters/dead/blend_amount"] = deadVal
