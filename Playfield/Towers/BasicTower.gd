tool

extends Tower

func _draw() -> void:
    if not Engine.editor_hint:
        return
    
    draw_rect(Rect2(position, 16 * tile_size), Color.red)
