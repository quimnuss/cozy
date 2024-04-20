extends CharacterBody2D

class_name Player

const SPEED = 200.0

@export var min_direction : Vector2 = Vector2(1, -0.1)
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var fire_particles = $FireParticles

var water_level : float = 100
var max_water_level : float = 100
var light_level : float = 100
var max_light_level : float = 100

var water_delta : float = 25
var light_delta : float = 50
const BURN_DELTA : float = 30

var water_degrowth_rate : float = 3
var base_light_degrowth_rate : float = 10
var lit : float = 0
var current_light_growth_rate : float

var velocity_degrowth_impact : float = 10

signal is_watered
signal is_lit

signal water_changed(level_percent : float)
signal light_changed(level_percent : float)

signal death

@export var can_die : bool = true

var can_move : bool = true

var is_burning : bool = false

var current_water_delta : float

signal build_changed

func _ready():
    Global.player = self

func upgrade(goal_num : int):
    match goal_num:
        0:
            max_water_level = 200
            #water_level = max_water_level

    build_changed.emit()

func water():
    current_water_delta = water_delta
    water_level = clamp(water_level+water_delta,0,max_water_level)
    is_watered.emit()
    water_changed.emit(water_level/max_water_level)

func light(ratio = 1):
    lit = light_delta*ratio
    #light_level = clamp(current_light_delta,0,max_light_level)
    #is_lit.emit()
    #light_changed.emit(light_level/max_light_level)

func set_burn(new_is_burning : bool):
    is_burning = new_is_burning
    if is_burning:
        fire_particles.emitting = true
        fire_particles.restart()
    else:
        fire_particles.emitting = false


func respawn():
    light_level = max_light_level
    water_level = max_water_level
    set_burn(false)

func _process(delta):

    var actual_burn_impact = BURN_DELTA if is_burning else 0
    var velocity_water_degrowth_rate : float = water_degrowth_rate + (velocity.length()/SPEED)*velocity_degrowth_impact + actual_burn_impact

    current_light_growth_rate = -base_light_degrowth_rate + lit

    water_level = clamp(water_level - velocity_water_degrowth_rate*delta, 0, max_water_level)
    light_level = clamp(light_level + current_light_growth_rate*delta, 0, max_light_level)

    #water_changed.emit(water_level/max_water_level)
    #light_changed.emit(light_level/max_light_level)

    if can_die and (water_level == 0 or light_level == 0):
        death.emit()

func _physics_process(delta):
    if not can_move:
        velocity = Vector2(0,0)
        return

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
