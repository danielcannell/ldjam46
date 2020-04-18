extends Node2D


func _ready():
    pass


func _process(delta):
    var size := get_viewport_rect().size - Vector2(180, 0)
    $ViewportContainer.rect_size = size
    $ViewportContainer/Viewport.size = size
