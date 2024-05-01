extends Button


const MASTER_VOLUME : String = 'Master'


func _on_toggled(toggled_on):
    var volume = 1 if toggled_on else 0
    var bus_index = AudioServer.get_bus_index(MASTER_VOLUME)
    AudioServer.set_bus_volume_db(bus_index, linear_to_db(volume))
