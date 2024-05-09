extends HSlider

@export var bus_name : String = 'Master'

func _ready() -> void:
    sync_volume()

func sync_volume():
    var bus_index = AudioServer.get_bus_index(bus_name)
    var volume : float = db_to_linear(AudioServer.get_bus_volume_db(bus_index))
    value = volume

func _on_value_changed(new_value):
    Config.set_bus_volume(bus_name, new_value)


func _on_visibility_changed():
    sync_volume()
