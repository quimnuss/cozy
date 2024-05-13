extends Node2D
@onready var player = $Player
@onready var player_camera : GrowthCamera = $Player/Camera2D

@onready var start_position = $StartPosition
@onready var trail_man = $TrailMan
@onready var win_scene = $WinScene
@onready var ui = $UI
@onready var camera_2d = $WinScene/Camera2D
@onready var outro_animation_player = $WinScene/SceneModulate/AnimationPlayer
@onready var final_phrase_label = $WinScene/CenterContainer/FinalPhraseLabel
@onready var info = $Info

@onready var sprout_label = $Info/SproutLabel
@onready var goal_reached_audio = $AudioSfx/GoalReachedAudio
@onready var welcome_background_music = $AudioSfx/WelcomeBackgroundMusic
@onready var game_background_music = $AudioSfx/GameBackgroundMusic
@onready var audio_sfx = $AudioSfx
@onready var game_won_audio = $AudioSfx/GameWonAudio
@onready var credits_music = $AudioSfx/CreditsMusic

@export var next_level = 'res://scenes/level_1.tscn'

enum GameStates {CUTSCENE, WELCOME, RUNNING, PAUSED, SPAWN}
var game_state = GameStates.CUTSCENE


# Called when the node enters the scene tree for the first time.
func _ready():
    #player.water_changed.connect(water_level.set_value_no_signal)
    #player.light_changed.connect(light_level.set_value_no_signal)

    var goals : Array = get_tree().get_nodes_in_group('goals')
    for goal : Goal in goals:
        goal.goal_reached.connect(_on_goal_reached)

    stop_run()

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

func fade_out(node : Node):
    var tween : Tween = get_tree().create_tween()
    tween.tween_property(node, "modulate:a", 0, 1).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
    tween.play()
    tween.finished.connect(node.queue_free)

func start_run():
    player.set_process(true)
    trail_man.set_process(true)
    player.can_move = true

func stop_run():
    player.set_process(false)
    trail_man.set_process(false)
    player.can_move = false

func start_game():
    fade_out(info)
    player.visible = true
    start_run()
    audio_sfx.fade_out(welcome_background_music, 3)
    audio_sfx.fade_in(game_background_music, 3)

var input_knock_knock : int = 3

func knockknock():
    player_camera.add_trauma(0.4)
    input_knock_knock -= 1

func _input(event):
    if game_state == GameStates.CUTSCENE:
        if event.is_action_pressed("main_action") or event.is_action_pressed("move_up"):
            print('TODO skip! TODO start on cutscene optional?')
            game_state = GameStates.WELCOME
    elif game_state == GameStates.WELCOME:
        var is_keyboard = (event.is_action_pressed("move_left") \
                        or event.is_action_pressed("move_right") \
                        or event.is_action_pressed("move_up") \
                        or event.is_action_pressed("move_down"))
        var is_joy = event.is_action_pressed("main_action") and event is InputEventJoypadButton
        var is_mouse =  event.is_action_pressed("main_action") and event is InputEventMouseButton

        if is_keyboard or is_joy or is_mouse:
            if input_knock_knock <= 0:
                game_state = GameStates.RUNNING
                start_game()
            else:
                knockknock()
    elif game_state == GameStates.SPAWN:
        if event.is_action_pressed("main_action") or event.is_action_pressed("move_up"):
            start_run()

func _process(_delta):
    if Input.is_action_just_pressed("respawn"):
        respawn()

    if OS.is_debug_build() and Input.is_action_just_pressed("cheat"):
        if not player.can_die:
            win()
        player.can_die = false
        #play_outro()

    if Input.is_action_just_pressed("quit"):
        _on_quit_button_pressed()

    ui.set_water_level(player.water_level*100/player.max_water_level)
    ui.set_light_level(player.light_level*100/player.max_light_level)

func respawn():
    trail_man.to_freezer()
    player.global_position = start_position.global_position
    player.respawn()
    game_state = GameStates.SPAWN
    stop_run()

func _on_player_death():
    respawn()

func win():
    game_won_audio.play()
    audio_sfx.fade_out(game_background_music, 3)
    audio_sfx.fade_in(credits_music, 2)
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
    audio_sfx.fade_out(credits_music, 4)
    audio_sfx.fade_in(game_background_music, 4)
    get_tree().change_scene_to_file(next_level)
#
    #var previous_camera : Camera2D = get_viewport().get_camera_2d()
    #camera_2d.global_position = previous_camera.global_position
    #camera_2d.offset = previous_camera.offset
#
    #camera_2d.make_current()
    #camera_2d.position_smoothing_speed = 1.0
    #camera_2d.global_position = start_position.global_position
    #await get_tree().create_timer(1).timeout

func _on_goal_3_goal_reached(_goal_num):
    win()


func _on_generic_goal_reached(_goal_num):
    goal_reached_audio.play()


func _on_quit_button_pressed():
    get_tree().quit()


func _on_restart_button_pressed():
    get_tree().reload_current_scene()





func _on_main_animation_player_animation_finished(anim_name):
    if anim_name == 'fly_in_cutscene':
        $MainAnimationPlayer/Dandelion.queue_free()
        game_state = GameStates.WELCOME

