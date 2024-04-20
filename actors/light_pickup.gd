extends Node2D
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var point_light_2d = $PointLight2D

var is_pickable : bool = true

var invader : Player

@onready var light_collision_shape_2d : CollisionShape2D = $LightArea2D/CollisionShape2D
@onready var burn_collision_shape_2d = $BurnArea2D/CollisionShape2D

var light_range_max : float
var light_range_min : float

func _ready():
    light_range_max = light_collision_shape_2d.shape.radius
    light_range_min = burn_collision_shape_2d.shape.radius

func picked_up(player : Player):
    player.light()
    animated_sprite_2d.play('dissolve')
    point_light_2d.visible = false
    is_pickable = false

func _physics_process(delta):
    if invader:
        var invader_distance : float = self.global_position.distance_to(invader.global_position)
        var ratio = clamp((invader_distance - light_range_min)/(light_range_max - light_range_min),0,1)
        invader.light(ratio)




func _on_light_area_2d_body_entered(body):
    if body is Player:
        animated_sprite_2d.play('light')
        point_light_2d.modulate.a = 0.6
        invader = body as Player


func _on_light_area_2d_body_exited(body):
    animated_sprite_2d.play('default')
    point_light_2d.modulate.a = 1
    invader.light(0)
    invader = null


func _on_burn_area_2d_body_entered(body):
    if body is Player:
        body.set_burn(true)


func _on_burn_area_2d_body_exited(body):
    if body is Player:
        body.set_burn(false)
