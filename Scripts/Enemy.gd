extends CharacterBody3D

#Set animation related information
enum{IDLE,WALK,RUN,HURT,AIM,ATTACK,DEAD} #Define animation states
var curAnim: int = IDLE #set current animation state
@onready var animTree: AnimationTree = $AnimationTree #Animation Tree node for blending animations
@onready var health: Node = $Health #Health script

#Get Player Node and set variables for detection and distance
@onready var player = $"../Player" #Player node, same tree as player in main scene
var detectPlayer: bool = false #if player is detected
@export var detectDistance: float = 5.0 #Distance to detect Player
@export var stopDetection: float = 10.0 #Stops following Player

const WALKSPEED: float = 1.5
const TURNSPEED: float = 2.0

#Attack related Variables
@export var atkCooldown: float = 1.0 #time in seconds
@export var atkTimer: float = 0.0 #time till next attack
@export var atkRange: float = 1.0 #distance to judge weather to attack
@onready var atkRay: RayCast3D = $AttackRay

#Main funciton / process every delta (time) interval
func _physics_process(delta: float) -> void:
	
	#check if Enemy is still alive
	if !health.IsAlive():
		curAnim = DEAD
		self.get_node("EnemyCollider").disabled = true
		animTree.AnimationChange(delta, curAnim)
		return

	#Cooldown Timer for Attack / decrement timer
	if atkTimer > 0:
		atkTimer -= delta
	elif atkTimer <= 0 && curAnim == ATTACK:
		curAnim = IDLE

	#call for player detection
	detectPlayer = PlayerDetected()
	#Get direction to player
	var direction: Vector3 = (player.global_transform.origin - global_transform.origin).normalized()

	#See if player is detected and start movment
	match true:
		detectPlayer:
			if curAnim == ATTACK:
				pass
			else:
				MoveEnemy(delta,direction)
				#see if distance to player is within attack range
				if global_transform.origin.distance_to(player.global_transform.origin) <= atkRange:
					EnemyAttack(direction)
				detectPlayer = OutsideRange()
		_:
			curAnim = IDLE
	
	#call method from animation tree that sets the new animation blends
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

	#move the enemy forward
	global_transform.origin += forward * newSpeed * delta

	#call rotation function to turn the Enemy
	RotateEnemy(delta, dir, targetAngle, currentAngle)

	#set curAnim to WALK
	curAnim = WALK

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

func EnemyAttack(dir: Vector3) -> void:
	if atkTimer <= 0: #check if cooldown Timer has elapsed
		#see if player is in front of enemy
		var angle: float = atan2(dir.x, dir.z) - rotation.y
		angle = abs(wrapf(angle, -PI, PI)) #Normalize angle range in radians
		if angle <= deg_to_rad(22.5): #45 degrees / 22.5 on either side
			curAnim = ATTACK
			atkTimer = atkCooldown #reset cooldown
			print("enemy attack initiated, cooldown started again")

func DisableAttackAnimation() -> void:
	curAnim = IDLE