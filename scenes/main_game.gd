extends Node2D
@onready var player = $Player
@onready var water_level : ProgressBar = %WaterProgressBar
@onready var light_level : ProgressBar = %LightProgressBar
@onready var start_position = $StartPosition
@onready var trail_man = $TrailMan
@onready var win_scene = $WinScene
@onready var ui = $UI


# Called when the node enters the scene tree for the first time.
func _ready():
    #player.water_changed.connect(water_level.set_value_no_signal)
    #player.light_changed.connect(light_level.set_value_no_signal)

    var goals : Array = get_tree().get_nodes_in_group('goals')
    for goal : Goal in goals:
        goal.goal_reached.connect(_on_goal_reached)

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

func _process(delta):
    if Input.is_action_just_pressed("respawn"):
        respawn()

    if Input.is_action_just_pressed("cheat"):
        win()

    water_level.set_value_no_signal(player.water_level)
    light_level.set_value_no_signal(player.light_level)

func respawn():
    trail_man.to_freezer()
    player.global_position = start_position.global_position
    player.respawn()

func _on_player_death():
    respawn()

func win():
    win_scene.play_win()
    var spore = load("res://actors/spore.tscn").instantiate()
    spore.global_position = player.global_position
    ui.visible = false
    player.can_move = false
    player.velocity = Vector2(0,0)
    player.set_process(false)
    add_child(spore)


func _on_goal_3_goal_reached(goal_num):
    win()
