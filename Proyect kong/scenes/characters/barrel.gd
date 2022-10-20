extends KinematicBody2D	
class_name Barrel

onready var animation: AnimationPlayer = $AnimationPlayer
onready var state_machine = $AnimationTree.get("parameters/playback")

const SPEED: int = 50
const GRAVITY: int = 200
const UP_VECTOR: Vector2 = Vector2(0,-1) #indicator, how the up direction is defined 

var velocity: Vector2 = Vector2()
var direction: int = 1 # 1 = right, -1 left

var is_falling_ladder: bool = false # indicator, if the barrel is falling down a ladder




func _process(delta):
	check_destroy()
	is_falling_ladder = check_ladder_falling()

	if is_on_floor() and not is_falling_ladder:
		velocity.y = 0
		
		if direction == 1:
			state_machine.travel("move")
		else:
			state_machine.travel("move")

		if floor(position.x) ==216:
			direction = -1
		if floor(position.x) == 8:
			direction = 1
			
		velocity.x = direction * SPEED
	else:
		velocity.x = 0
		velocity.y += GRAVITY * delta # make fall faster the longer the fall

	move_and_slide_with_snap(velocity, Vector2(0,1), UP_VECTOR)
	
func check_ladder_falling() -> bool:
	if not is_falling_ladder:
		if check_for_ladder():
			randomize()
			var random_val: int = randi() % 300 #33% chance of falling

			if(random_val < 10):
				state_machine.travel("fall")
				position.y += 10
				direction = -1 * direction
				return true

		return false

	else:
		if is_on_floor() and not check_for_ladder():
			return false
		else:
			return true
	
			
func check_for_ladder() -> bool:
	var collider = $RayCast2D.get_collider()
	
	if collider != null:
		return collider.name =="Ladder"
	return false
	
func check_destroy() -> void:
	if floor(position.x) == 8 and position.y > 280:
		 queue_free()

	if get_slide_count() > 0:
		for i in range(get_slide_count()):
			if get_slide_collision(i).collider != null:
				if get_slide_collision(i).collider.name == "Barrel":
					queue_free()
			

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

