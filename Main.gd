extends Node2D


onready var game_ui := $GameUI
onready var playfield := $ViewportContainer/Viewport/Playfield


func _ready():

    game_ui.set_buildable_items(Globals.TOWERS)
    game_ui.set_status_bars(Globals.BARS)

    for bar in Globals.BARS:
        game_ui.on_status_change(bar, 0.0)

    var err: int = 0
    err = playfield.connect("status_changed", game_ui, "on_status_change"); assert(err == 0)
    err = playfield.connect("wave_start", game_ui, "on_wave_start"); assert(err == 0)
    err = playfield.connect("spawns_changed", game_ui, "on_spawns_change"); assert(err == 0)
    err = playfield.connect("kills_changed", game_ui, "on_kills_change"); assert(err == 0)


func _process(_delta):
    var size := get_viewport_rect().size
    $ViewportContainer.rect_size = size
    $ViewportContainer/Viewport.size = size
