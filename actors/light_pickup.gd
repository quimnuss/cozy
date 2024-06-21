extends Node2D

class_name LightPickup

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var point_light_2d = $PointLight2D

var is_pickable : bool = true

var invader : Player

@onready var light_collision_shape_2d : CollisionShape2D = $LightArea2D/CollisionShape2D
@onready var burn_collision_shape_2d : CollisionShape2D = $BurnArea2D/CollisionShape2D

var gather_ui_position : Vector2 = Vector2(200, 50)

var light_range_max : float
var light_range_min : float

@onready var pickup_name = $PickupName

func _ready():
    light_range_max = light_collision_shape_2d.shape.radius
    light_range_min = burn_collision_shape_2d.shape.radius

    if OS.is_debug_build():
        var debug_cam = Camera2D.new()
        add_child(debug_cam)

func set_title():
    pickup_name.set_text(self.name)

func _draw():
    draw_arc(Vector2(0,0), light_collision_shape_2d.shape.radius, 0, 2*PI, 50, Color(1,1,0), 5)
    draw_arc(Vector2(0,0), burn_collision_shape_2d.shape.radius, 0, 2*PI, 50, Color(1,0.2,0), 5)

func picked_up(player : Player):
    player.light()
    animated_sprite_2d.play('dissolve')
    point_light_2d.visible = false
    is_pickable = false

func spawn_gather(amount : int = 4):
    for i in range(amount):
        var droplet : GatherDroplet = GatherDroplet.Instantiate(self.global_position, gather_ui_position)
        droplet.modulate = Color(0.949, 0.886, 0.02)
        self.add_child(droplet)

var elapsed = 0
const LIGHT_PARTICLES = 1

func _physics_process(delta):
    if invader:
        var invader_distance : float = self.global_position.distance_to(invader.global_position)
        # TODO use curve maybe its easier and we can make exp
        var ratio = 1 - clamp((invader_distance - light_range_min)/(light_range_max - light_range_min),0,1)
        invader.light(ratio)
        elapsed += delta
        if elapsed > (1-ratio)*LIGHT_PARTICLES + 0.5:
            elapsed = 0
            spawn_gather(1 + ratio*4)


func _on_light_area_2d_body_entered(body):
    if body is Player:
        animated_sprite_2d.play('light')
        point_light_2d.energy = 0.7
        invader = body as Player
        queue_redraw()

func _on_light_area_2d_body_exited(body):
    if body is Player:
        animated_sprite_2d.play('default')
        point_light_2d.energy = 1
        invader.light(0)
        invader = null


func _on_burn_area_2d_body_entered(body):
    if body is Player:
        body.set_burn(true)
        queue_redraw()


func _on_burn_area_2d_body_exited(body):
    if body is Player:
        body.set_burn(false)
