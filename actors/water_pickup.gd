extends Node2D
@onready var animated_sprite_2d = $AnimatedSprite2D

var is_pickable : bool = true

func _ready():
    animated_sprite_2d.play('default')

func picked_up(player):
    player.water()
    animated_sprite_2d.play('dissolve')
    is_pickable = false

func _on_area_2d_body_entered(body):
    if body is Player and is_pickable:
        picked_up(body)


func _on_animated_sprite_2d_animation_finished():
    if animated_sprite_2d.animation == 'undissolve':
        animated_sprite_2d.play('default')


func _on_area_2d_body_exited(body):
    animated_sprite_2d.play('undissolve')
    is_pickable = true
