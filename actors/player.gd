extends CharacterBody2D

class_name Player

const SPEED = 200.0
const JUMP_VELOCITY = -400.0



func _physics_process(delta):

    # Handle jump.
    if Input.is_action_just_pressed("ui_accept") and is_on_floor():
        velocity.y = JUMP_VELOCITY

    var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
    if direction:
        velocity = velocity.move_toward(direction*Vector2(SPEED,SPEED), SPEED*delta)
    else:
        velocity = velocity.move_toward(Vector2(0,0),SPEED*delta)

    if velocity:
        rotation = velocity.angle() + PI/2

    move_and_slide()
