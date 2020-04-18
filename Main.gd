extends Node2D


func _ready():

    get_node("GameUI").set_buildable_items(Globals.TOWERS)
    get_node("GameUI").set_status_bars(Globals.BARS)

    # set demo bars for fun
    for bar in Globals.BARS:
        get_node("GameUI").on_status_change(bar, rand_range(0, 100))

func _process(_delta):
    var size := get_viewport_rect().size
    $ViewportContainer.rect_size = size
    $ViewportContainer/Viewport.size = size
