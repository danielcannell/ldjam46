extends Node2D


onready var game_ui = $GameUI


func _ready():

    game_ui.set_buildable_items(Globals.TOWERS)
    game_ui.set_status_bars(Globals.BARS)

    # set demo bars for fun
    for bar in Globals.BARS:
        game_ui.on_status_change(bar, rand_range(0, 100))


func _process(_delta):
    var size := get_viewport_rect().size
    $ViewportContainer.rect_size = size
    $ViewportContainer/Viewport.size = size
