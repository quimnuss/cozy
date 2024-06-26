extends CharacterBody2D

class_name Player

const SPEED = 200.0

@export var min_direction : Vector2 = Vector2(1, -0.1)
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var fire_particles = $FireParticles
@onready var sparkles = $Sparkles
@onready var lit_audio = $AudioSfx/LitAudio
@onready var burn_audio = $AudioSfx/BurnAudio
@onready var water_audio = $AudioSfx/WaterAudio
@onready var audio_sfx = $AudioSfx

var water_level : float = 100
var max_water_level : float = 100
var light_level : float = 100
var max_light_level : float = 100

const STAT_DANGER : float = 40

var water_delta : float = 25
var light_delta : float = 50
const BURN_DELTA : float = 60

@export var light_immune : bool = false
@export var water_immune : bool = false

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
var is_danger : bool = false

var current_water_delta : float

signal build_changed

func _ready():
    Global.player = self

func upgrade(goal_num : int):
    match goal_num:
        0:
            max_water_level += 50
            #water_level = max_water_level
        1:
            max_light_level += 50
        2:
            max_water_level += 50

    build_changed.emit()

func water():
    if water_immune:
        return
    current_water_delta = water_delta
    water_level = clamp(water_level+water_delta,0,max_water_level)
    is_watered.emit()
    water_changed.emit(water_level/max_water_level)
    #if not water_audio.playing:
    water_audio.play()

func light(ratio = 1):
    if light_immune:
        return
    lit = light_delta*ratio
    if ratio > 0:
        sparkles.visible = true
        sparkles.modulate.a = ratio
        if not lit_audio.playing:
            lit_audio.play()
    else:
        sparkles.visible = false
        if lit_audio.playing:
            audio_sfx.fade_out(lit_audio)

    #light_level = clamp(current_light_delta,0,max_light_level)
    #is_lit.emit()
    #light_changed.emit(light_level/max_light_level)

func set_burn(new_is_burning : bool):
    if light_immune or water_immune:
        return
    is_burning = new_is_burning
    if is_burning:
        fire_particles.emitting = true
        fire_particles.restart()
        if not burn_audio.playing:
            burn_audio.play()
    else:
        fire_particles.emitting = false
        if burn_audio.playing:
            audio_sfx.fade_out(burn_audio)

func respawn():
    light_level = max_light_level
    water_level = max_water_level
    set_burn(false)
    animated_sprite_2d.modulate = Color(1,1,1,1)
    self.rotation = 0

func _process(delta):

    if not light_immune:
        current_light_growth_rate = -base_light_degrowth_rate + lit
        light_level = clamp(light_level + current_light_growth_rate*delta, 0, max_light_level)

    if not water_immune:
        var actual_burn_impact = BURN_DELTA if is_burning else 0.0
        var velocity_water_degrowth_rate : float = water_degrowth_rate + (velocity.length()/SPEED)*velocity_degrowth_impact + actual_burn_impact
        water_level = clamp(water_level - velocity_water_degrowth_rate*delta, 0, max_water_level)

    var worse_stat = min(water_level, light_level)
    var danger_color = Color(1,1,1)
    var ratio = 1
    if worse_stat < STAT_DANGER:
        is_danger = true
        ratio = clamp(worse_stat/STAT_DANGER,0,1)
        if water_level < light_level:
            danger_color = Color(0.5,0,0)
        else:
            danger_color = Color(1,0,1)
    elif is_danger:
        is_danger = false
        animated_sprite_2d.modulate = Color(1,1,1,1)

    animated_sprite_2d.modulate = Color(1,1,1)*ratio + (1-ratio)*danger_color

    #water_changed.emit(water_level/max_water_level)
    #light_changed.emit(light_level/max_light_level)

    if can_die and (water_level == 0 or light_level == 0):
        death.emit()

func _physics_process(delta):
    if not can_move:
        velocity = Vector2(0,0)
        return

    var direction: Vector2
    if Global.mouse_movement:
        if global_position.distance_to(get_global_mouse_position()) > 5:
            direction = (get_global_mouse_position() - global_position).normalized()
    else:
        direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")

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
