extends Node2D
@onready var animated_sprite_2d = $AnimatedSprite2D

var is_pickable : bool = true

var gather_ui_position : Vector2 = Vector2(200, 50)

func _ready():
    animated_sprite_2d.play('default')


func picked_up(player):
    player.water()
    animated_sprite_2d.play('dissolve')
    is_pickable = false
    #var screen_tranformer : Transform2D = (get_viewport().get_screen_transform() * get_viewport().get_canvas_transform()).affine_inverse()
    #var target_position : Vector2 = screen_tranformer*gather_ui_position

    #var sprite = Sprite2D.new()
    #sprite.global_position = target_position
    #sprite.texture = load("res://assets/fire.png")
    #get_tree().root.get_child(0).add_child(sprite)

    for i in range(4):
        var droplet : GatherDroplet = GatherDroplet.Instantiate(self.global_position, gather_ui_position)
        droplet.modulate = Color(0.369, 0.808, 0.973)
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
