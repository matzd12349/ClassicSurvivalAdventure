extends RayCast3D

class_name AttackRay

#Properties of attack class
@export var damage: int = 1 # Default damage value, can be set from edditor: Make sure to set unique to local

#The following two functions are used to disable/enable the attack RayCast2D to avoid unnecessary constant calling
func EnableRay() -> void:
	self.enabled = true
func DisableRay() -> void:
	self.enabled = false

#set/get Damage on AttackRay
func setDamage(newDamage: int) -> void:
	damage = newDamage
func getDamage() -> int:
	return getDamage()

#Call damage fucntin on collided Object
func CallTakeDamage() -> void:
	if self.get_collider() != null:
		self.get_collider().get_node("Health").TakeDamage(damage)
	pass