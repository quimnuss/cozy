extends Node

const CONFIG_FILE : String = "user://cozygrowth.cfg"

const MASTER_SECTION : String = 'master'

var config : ConfigFile = ConfigFile.new()

func _ready():
    var err: Error = config.load(CONFIG_FILE)
    if err != OK:
        prints("User config", ProjectSettings.globalize_path(CONFIG_FILE), "failed to load.")
    else:
        prints("User config", ProjectSettings.globalize_path(CONFIG_FILE), "exists.")

    # MASTER section

    for bus_idx in range(AudioServer.bus_count):
        var bus_name : String = AudioServer.get_bus_name(bus_idx)
        var volume : float = config.get_value(MASTER_SECTION, bus_name, 1)
        AudioServer.set_bus_volume_db(bus_idx, linear_to_db(volume))

func set_bus_volume(bus_name : String, volume : float):
    var bus_index = AudioServer.get_bus_index(bus_name)
    AudioServer.set_bus_volume_db(bus_index, linear_to_db(volume))
    config.set_value(MASTER_SECTION, bus_name, volume)
    config.save(CONFIG_FILE)

