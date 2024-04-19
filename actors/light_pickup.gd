extends Node2D
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var point_light_2d = $PointLight2D

var is_pickable : bool = true

func _ready():
    animated_sprite_2d.play('default')

func picked_up(player):
    player.light()
    animated_sprite_2d.play('dissolve')
    point_light_2d.visible = false
    is_pickable = false

func _on_area_2d_body_entered(body):
    if body is Player and is_pickable:
        picked_up(body)


func _on_animated_sprite_2d_animation_finished():
    if animated_sprite_2d.animation == 'dissolve':
        queue_free()
