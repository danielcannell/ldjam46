extends Node2D


onready var game_ui = $GameUI
onready var playfield = $ViewportContainer/Viewport/Playfield


func _ready():

    game_ui.set_buildable_items(Globals.TOWERS)
    game_ui.set_status_bars(Globals.BARS)

    for bar in Globals.BARS:
        game_ui.on_status_change(bar, 0.0)

    assert(playfield.connect("status_changed", game_ui, "on_status_change") == 0)


func _process(_delta):
    var size := get_viewport_rect().size
    $ViewportContainer.rect_size = size
    $ViewportContainer/Viewport.size = size
