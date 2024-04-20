extends Node2D

class_name Spore

@onready var animation_player = $AnimationPlayer
@onready var camera_2d = $Camera2D
@onready var animated_sprite_2d = $SporeDisplay/AnimatedSprite2D
@onready var camera_marker_2d = $CameraMarker2D

signal animation_finished

# Called when the node enters the scene tree for the first time.
func _ready():
    var main_camera = get_viewport().get_camera_2d()
    camera_2d.global_position = main_camera.global_position
    camera_2d.offset = main_camera.offset
    #main_camera.reparent(camera_marker_2d)
    #main_camera.position = Vector2(0,0)
    #camera_2d = main_camera # loses animation track

    # call deferred
    var foo = await get_tree().create_timer(0.3).timeout
    camera_2d.make_current() # bumps
    animation_player.play('fly_away', -1, 0.5)
    animated_sprite_2d.play('default')


func _on_animation_player_animation_finished(_anim_name):
    animation_finished.emit()
    queue_free()
