extends KinematicBody2D

const SPEED = 60
const LADDER_SPEED = 20
var GRAVITY = 150
const JUMP_POWER = 90

const UP_VECTOR = Vector2(0,-1)
var velocity = Vector2()
var jump_mode = false
var is_connected_to_ladder = false
var on_floor
var score
onready var state_machine = $AnimationTree.get("parameters/playback")
enum states {IDLE, JUMPING, WALKING, C_LADDER}
var actual_state
var horizontal
var dead

	



func _ready():
	dead = false

func _process(delta):
	if not dead:
		velocity.x = 0
		if is_connected_to_ladder:
			velocity.y = 0
		else:
			velocity.y += GRAVITY*delta
			
		if jump_mode and is_on_floor():
			jump_mode = false
		
		check_key_input()
		
		
		if is_connected_to_ladder:
			$Foots.enabled = false
			$CollisionShape2D.set_deferred("disabled", true)
			standard_animation_ladder()
		else: 
			$Foots.enabled = true
			$CollisionShape2D.set_deferred("disabled", false)
			standard_animation()
		velocity = move_and_slide(velocity,UP_VECTOR)
		
func check_key_input() -> void:
	
	if not is_connected_to_ladder:
		if Input.is_action_pressed("move_left") :
			velocity.x = -1 * SPEED
		if Input.is_action_pressed("move_right") :
			velocity.x = 1 * SPEED
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = -JUMP_POWER
			jump_mode = true
			
	elif is_connected_to_ladder and is_on_floor():
		if Input.is_action_pressed("move_left") :
			velocity.x = -1 * SPEED
		if Input.is_action_pressed("move_right") :
			velocity.x = 1 * SPEED
			
	else:
		if Input.is_action_pressed("jump"):
			velocity.y = -1 * LADDER_SPEED
		if Input.is_action_pressed("down_stairs"):
			velocity.y = 1 * LADDER_SPEED
		
			


func standard_animation() -> void:
	if velocity.x > 0:
		$Sprite.flip_h = false
		if jump_mode:
			
			state_machine.travel("jump")
			$mario_jump.play()
		else:
			
			state_machine.travel("walk")
			
	elif velocity.x < 0:
		$Sprite.flip_h = true
		if jump_mode:
			state_machine.travel("jump") 
		else:
			
			state_machine.travel("walk")
	else:
		if not $Sprite.frame == 7:
			if jump_mode:
				
				state_machine.travel("jump") 
				$mario_jump.play()
			else:
				 state_machine.travel("idle")

func standard_animation_ladder():
	if is_on_floor():
		if velocity.x > 0:
			$Sprite.flip_h = false
			
			state_machine.travel("walk")
		elif velocity.x < 0:
			$Sprite.flip_h = true
			
			state_machine.travel("walk")
		else:
			if not $Sprite.frame == 7:
				state_machine.travel("idle")
	else:
		if velocity.y != 0:
			state_machine.travel("stairs")

	

func _on_Hurt_box_area_entered(area):
	if area.name == "Ladder":
		is_connected_to_ladder = true



func _on_Hurt_box_area_exited(area):
	if area.name == "Ladder":
		is_connected_to_ladder = false



func _on_Hurt_dead_area_entered(area):
	print("Mi hora a llegado")
	dead = true
	state_machine.travel("dead")
	get_tree().change_scene("res://scenes/End.tscn")
	
