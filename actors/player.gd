extends CharacterBody2D

class_name Player

const SPEED = 200.0
const JUMP_VELOCITY = -400.0

@export var min_direction : Vector2 = Vector2(1, -0.1)

var water_level : float = 100
var max_water_level : float = 100
var light_level : float = 100
var max_light_level : float = 100

var water_delta : float = 25
var light_delta : float = 25

var water_degrowth_rate : float = 10
var light_degrowth_rate : float = 3

var velocity_degrowth_impact : float = 10

signal is_watered
signal is_lit

signal water_changed(level_percent : float)
signal light_changed(level_percent : float)

signal death

@export var can_die : bool = true

func _ready():
    Global.player = self

func water():
    water_level = clamp(water_level+water_delta,0,max_water_level)
    is_watered.emit()
    water_changed.emit(water_level/max_water_level)

func light():
    light_level = clamp(light_level+light_delta,0,max_light_level)
    is_lit.emit()
    light_changed.emit(light_level/max_light_level)

func respawn():
    light_level = max_light_level
    water_level = max_water_level

func _process(delta):

    var velocity_light_degrowth_rate : float = light_degrowth_rate + velocity.length()*velocity_degrowth_impact

    water_level = clamp(water_level - water_degrowth_rate*delta, 0, max_water_level)
    light_level = clamp(light_level - light_degrowth_rate*delta, 0, max_light_level)
    water_changed.emit(water_level/max_water_level)
    light_changed.emit(light_level/max_light_level)

    if can_die and (water_level == 0 or light_level == 0):
        death.emit()

func _physics_process(delta):

    # Handle jump.
    if Input.is_action_just_pressed("ui_accept") and is_on_floor():
        velocity.y = JUMP_VELOCITY

    var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
    if direction:
        direction = direction.clamp(Vector2(-1,-1), min_direction)
        velocity = velocity.move_toward(direction*Vector2(SPEED,SPEED), SPEED*delta)
    else:
        velocity = velocity.move_toward(Vector2(0,-50),SPEED*delta)

    if velocity:
        rotation = velocity.angle() + PI/2

    move_and_slide()

func goal0():
    pass

func goal1():
    pass

func goal2():
    pass

func goal3():
    pass
