extends CharacterBody3D

#Set animation related information
enum{IDLE,WALK,RUN,HURT,AIM,ATTACK,DEAD} #Define animation states
var curAnim: int = IDLE #set current animation state
@onready var animTree: AnimationTree = $AnimationTree #Animation Tree node for blending animations

#Get Player Node
@onready var player = $"../Player"
var detectPlayer: bool = false #if player is detected
@export var detectDistance: float = 5.0 #Distance to detect Player
@export var stopDetection: float = 10.0 #Stops following Player

const WALKSPEED: float = 1.5
const TURNSPEED: float = 1.5

#Main funciton / process every delta (time) interval
func _physics_process(delta: float) -> void:
	
	#call for player detection
	detectPlayer = PlayerDetected()
	#Get direction to player
	var direction: Vector3 = (player.global_transform.origin - global_transform.origin).normalized()

	match true:
		detectPlayer:
			curAnim = WALK
			MoveEnemy(delta,direction)
			detectPlayer = OutsideRange()
		_:
			curAnim = IDLE
	animTree.AnimationChange(delta,curAnim)


#MOVEMENT
func MoveEnemy(delta: float,dir: Vector3) -> void:

	#Normalize the forward direction toward the player
	var forward = Vector3(sin(rotation.y), 0, cos(rotation.y)).normalized()

	#Calculate angle between Enemy direction and Plyaer direction
	var targetAngle: float = atan2(dir.x, dir.z) #angle from enemy facing direction to player position
	var currentAngle: float = rotation.y #current rotation based on y axis
	var differenceAngle: float = abs(targetAngle - currentAngle) #used to adjust speed of enemy

	#normalize angle range 0, PI : Godot uses radians to calculate rotation
	differenceAngle = min(differenceAngle, PI - differenceAngle)
	
	#variable of the adjusted walkspeed of enemy
	var newSpeed: float = WALKSPEED * (1 - differenceAngle / PI)

	#move the Player forward
	global_transform.origin += forward * newSpeed * delta

	#call rotation function to turn the Enemy
	RotateEnemy(delta, dir, targetAngle, currentAngle)

#ROTATION
func RotateEnemy(delta: float,dir: Vector3, endAngle: float, curAngle: float) -> void:
	
	#get angles
	endAngle = atan2(dir.x, dir.z) #angle from enemy facing direction to player position
	curAngle = rotation.y #current rotation based on y axis
	#calculate next rotation
	rotation.y = lerp_angle(curAngle, endAngle, TURNSPEED * delta)

#See if Player is within range
func PlayerDetected() -> bool:
	var distance: float = global_transform.origin.distance_to(player.global_transform.origin)
	return distance <= detectDistance

#see if player is still within agro range
func OutsideRange() -> bool:
	var distance: float = global_transform.origin.distance_to(player.global_transform.origin)
	return distance >= stopDetection
