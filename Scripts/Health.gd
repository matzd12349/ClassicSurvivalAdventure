extends Node

class_name Health

# Properties of Health Class
@export var maxHealth: int = 3
var currentHealth: int = 3

# Constructor
func _init(_maxHealth: int = maxHealth) -> void:
	maxHealth = _maxHealth
	currentHealth = maxHealth

# Take Damage
func TakeDamage(amount: int) -> void:
	currentHealth -= amount
	#Check if Character still has health left
	if currentHealth <= 0:
		currentHealth = 0
		print(name, ": ", get_instance_id(), " is Dead")
	else:
		print(name, ": ", get_instance_id(), " took ", amount, " damage!")

# Method to heal
func Heal(amount: int) -> void:
	currentHealth += amount
	#make sure not to go over maxHealth limit
	if currentHealth > maxHealth:
		currentHealth = maxHealth
	print(name, ": ", get_instance_id(), " took ", amount, " healing!")

# Check if character is dead
func IsAlive() -> bool:
	return currentHealth > 0

# Method to set max health and reset current health
func SetMaxHealth(newMaxHealth: int) -> void:
	maxHealth = newMaxHealth
	print(name, ": ", get_instance_id(), " health increased by ", newMaxHealth - maxHealth)
