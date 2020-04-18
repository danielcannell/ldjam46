extends Node2D


func _process(delta):
    var size := get_viewport_rect().size
    $ViewportContainer.rect_size = size
    $ViewportContainer/Viewport.size = size
