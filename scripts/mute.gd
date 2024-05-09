extends Button


const MASTER_VOLUME : String = 'Master'


func _on_toggled(toggled_on):
    var volume = 1 if toggled_on else 0
    Config.set_bus_volume(MASTER_VOLUME, volume)
