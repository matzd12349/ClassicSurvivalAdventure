extends CharacterBody3D

#Set animation related information
enum{IDLE,WALK,RUN,HURT,AIM,ATTACK,DEAD} #Animation States
var curAnim: int = IDLE 
@onready var animTree: AnimationTree = $AnimationTree #Animation Tree
@onready var health: Node = $Health #Health Class

#Movement Related Variables
const WALKSPEED: float = 3.0
const RUNSPEED: float = 6.0
const BACKSPEED: float = 1.5
const TURNSPEED: float = 120 #Degrees
const AIMSPEED: float = 60 #Degrees

#set currentSpeeds
var currentSpeed: float = 0
var currentTurn: float = 0

#Attack related Variables
@export var atkCooldown: float = 1.0 #seconds
var atkTimer: float = 0.0 #tracker
@onready var atkRay: RayCast3D = $AttackRay #object node

#Every time interval
func _physics_process(delta: float) -> void:

	#check if Alive
	if health.currentHealth > 0:
		pass
	else:
		curAnim = DEAD
		self.get_node("PlayerCollider").disabled = true
		animTree.AnimationChange(delta, curAnim)
		return

	#update attack cooldown
	if atkTimer > 0.0:
		atkTimer -= delta

	#set speed and check current animation
	SpeedAnimationCheck(delta)

	#Check if Aiming
	match curAnim:
		AIM:
			PlayerAttack()
		_:
			MovePlayer(currentSpeed)
	
	TurnPlayer(delta)

#MOVEMENT
func MovePlayer(speed: float) -> void:

	#get direction of player
	var direction: Vector3 = transform.basis.z

	#check Input for forward / backward / no input
	if Input.is_action_pressed("Forward"):
		velocity = direction * speed
	elif Input.is_action_pressed("Backward"):
		velocity = -direction * speed
	else:
		velocity = Vector3.ZERO

	move_and_slide()

#ROTATION
func TurnPlayer(delta: float) -> void:

	if Input.is_action_pressed("TurnLeft"):
		rotation_degrees.y += currentTurn * delta
		
	if Input.is_action_pressed("TurnRight"):
		rotation_degrees.y -= currentTurn * delta

#SPEED
func SpeedAnimationCheck(delta) -> void:

	#set bools to check certain actions
	var Aim: bool = Input.is_action_pressed("Aim")
	var Run: bool = !Input.is_action_pressed("Backward") && Input.is_action_pressed("Run") && IsMoving()
	var Back: bool = Input.is_action_pressed("Backward") && IsMoving()
	var Walk: bool = IsMoving()

	#Match if true to set speed and animation state
	match true:
		Aim:
			curAnim = AIM
			currentSpeed = WALKSPEED
			currentTurn = AIMSPEED
		Run:
			curAnim = RUN
			currentSpeed = RUNSPEED
			currentTurn = TURNSPEED
		Back:
			curAnim = WALK
			currentSpeed = BACKSPEED
			currentTurn = TURNSPEED
		Walk:
			curAnim = WALK
			currentSpeed = WALKSPEED
			currentTurn = TURNSPEED
		_:
			curAnim = IDLE
			currentSpeed = WALKSPEED
			currentTurn = TURNSPEED
	
	#determine change in animation tree
	animTree.AnimationChange(delta, curAnim)

#Check Movement
func IsMoving() -> bool:
	return Input.is_action_pressed("Forward") || Input.is_action_pressed("Backward") || Input.is_action_pressed("TurnLeft") || Input.is_action_pressed("TurnRight")

#Attack Input / Check/Reset Tracker / Call Damage Health Class
func PlayerAttack() -> void:
	if Input.is_action_just_pressed("Action"):
		if atkTimer <= 0.0:
			if curAnim == AIM:	
				atkRay.CallTakeDamage()
				print("Damage Called")
			atkTimer = atkCooldown


