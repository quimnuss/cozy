extends Node2D
@onready var animated_sprite_2d = $AnimatedSprite2D

var is_pickable : bool = true

var gather_ui_position : Vector2 = Vector2(70,-20)

func _ready():
    animated_sprite_2d.play('default')

func picked_up(player):
    player.water()
    animated_sprite_2d.play('dissolve')
    is_pickable = false
    var target_position : Vector2 = (get_viewport().get_screen_transform() * get_viewport().get_canvas_transform()).affine_inverse() * gather_ui_position
    var droplet : GatherDroplet = GatherDroplet.Instantiate(self.global_position, target_position)
    self.add_child(droplet)


func _on_area_2d_body_entered(body):
    if body is Player and is_pickable:
        picked_up(body)


func _on_animated_sprite_2d_animation_finished():
    if animated_sprite_2d.animation == 'undissolve':
        animated_sprite_2d.play('default')


func _on_area_2d_body_exited(body):
    if body is Player:
        await get_tree().create_timer(3).timeout
        animated_sprite_2d.play('undissolve')
        is_pickable = true
