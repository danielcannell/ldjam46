extends Node2D


var active: bool = false

var size: Vector2 = Vector2(0, 0)
var pos: Vector2 = Vector2(0, 0)
var color: Color = Color(0, 1, 0, 1)


func _draw():
    if active:
        draw_rect(Rect2(pos, size), color, false)


func begin(size_: Vector2, pos_: Vector2):
    size = size_
    pos = pos_
    self.active = true
    update()


func end():
    self.active = false
    update()


func set_pos(pos_: Vector2):
    self.pos = pos_
    update()
