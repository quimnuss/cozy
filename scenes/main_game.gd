extends Node2D
@onready var player = $Player
@onready var water_level : ProgressBar = %WaterProgressBar
@onready var light_level : ProgressBar = %LightProgressBar
@onready var start_position = $StartPosition
@onready var trail_man = $TrailMan
@onready var win_scene = $WinScene
@onready var ui = $UI
@onready var camera_2d = $WinScene/Camera2D

@onready var sprout_label = $Info/SproutLabel
@onready var goal_reached_audio = $GoalReachedAudio

var is_welcome : bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
    #player.water_changed.connect(water_level.set_value_no_signal)
    #player.light_changed.connect(light_level.set_value_no_signal)

    var goals : Array = get_tree().get_nodes_in_group('goals')
    for goal : Goal in goals:
        goal.goal_reached.connect(_on_goal_reached)

    player.set_process(false)
    trail_man.set_process(false)
    player.can_move = false

    #var done = await get_tree().create_timer(1).timeout
    #win_scene.play_win()

func _on_goal_reached(goal_num : int):
    match goal_num:
        0:
            player.goal0()
        1:
            player.goal1()
        2:
            player.goal2()
        3:
            player.goal3()

func start_game():
    sprout_label.visible = false
    player.set_process(true)
    trail_man.set_process(true)
    player.can_move = true


func _input(event):
    if is_welcome and (event.is_action_pressed("move_left") \
    or event.is_action_pressed("move_right") \
    or event.is_action_pressed("move_up") \
    or event.is_action_pressed("move_down")):
        is_welcome = false
        start_game()



func _process(_delta):
    if Input.is_action_just_pressed("respawn"):
        respawn()

    if Input.is_action_just_pressed("cheat"):
        win()

    if Input.is_action_just_pressed("quit"):
        _on_quit_button_pressed()


    water_level.set_value_no_signal(player.water_level*100/player.max_water_level)
    light_level.set_value_no_signal(player.light_level*100/player.max_light_level)

func respawn():
    trail_man.to_freezer()
    player.global_position = start_position.global_position
    player.respawn()

func _on_player_death():
    respawn()

func win():
    win_scene.play_win()
    var spore : Spore = load("res://actors/spore.tscn").instantiate()
    spore.animation_finished.connect(play_outro)
    spore.global_position = player.global_position
    ui.visible = false
    player.can_move = false
    player.velocity = Vector2(0,0)
    player.set_process(false)
    player.visible = false
    add_child(spore)

func play_outro():
    camera_2d.global_position = get_viewport().get_camera_2d().global_position
    camera_2d.make_current()
    camera_2d.position_smoothing_speed = 1.0
    await get_tree().create_timer(1).timeout
    camera_2d.global_position = start_position.global_position

func _on_goal_3_goal_reached(_goal_num):
    win()


func _on_generic_goal_reached(goal_num):
    goal_reached_audio.play()


func _on_quit_button_pressed():
    get_tree().quit()


func _on_restart_button_pressed():
    get_tree().reload_current_scene()
