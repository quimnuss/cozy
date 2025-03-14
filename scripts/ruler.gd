@tool
extends Line2D

@onready var label = $Label


func _process(delta):
    if $Label:
        label = $Label
        var target : Vector2 = points[1]
        $Label.position = target/2
        $Label.text = str(round(target.length()))


    #for child in self.owner.get_children():
        #if child is LightPickup:
            #print(child)
            #pass
