extends CharacterBody3D

#Set animation related information
enum{IDLE,WALK,RUN,HURT,AIM,ATTACK,DEAD} #Define animation states
var curAnim: int = IDLE #set current animation state
@onready var animTree: AnimationTree = $AnimationTree #Animation Tree node for blending animations

#Movement Related Variables
const WALKSPEED: float = 3.0
const RUNSPEED: float = 6.0
const BACKSPEED: float = 1.5
const TURNSPEED: float = 120 #Degrees of rotation
#While Aiming
const AIMSPEED: float = 60 #Degrees of rotation

#set currentSpeeds
var currentSpeed: float = 0
var currentTurn: float = 0

#Main function / processes severy delta (time) interval
func _physics_process(delta: float) -> void:

	#set speed and check current animation
	SpeedAnimationCheck(delta)

	#Check if Aiming
	if curAnim != AIM:
		#Move Player
		MovePlayer(currentSpeed)
	
	#Rotate player character
	TurnPlayer(delta)

#MOVEMENT
func MovePlayer(speed: float) -> void:

	var inputDir: Vector2 = Input.get_vector("TurnLeft", "TurnRight", "Forward", "Backward")
	var direction: Vector3 = (transform.basis * Vector3(0, 0, inputDir.y)).normalized()

	#perpetual movment when...
	if direction: #when pressed
		velocity.x = -direction.x * speed
		velocity.z = -direction.z * speed

	else: #when not pressed
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	
	#Move and Slide function does not handle rotation
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

#Check if moving
func IsMoving() -> bool:
	return Input.is_action_pressed("Forward") || Input.is_action_pressed("Backward") || Input.is_action_pressed("TurnLeft") || Input.is_action_pressed("TurnRight")
