extends Area2D


const SPEED: float = 1000.0


var dead: bool = false


func _ready() -> void:
    assert(connect("area_entered", self, "_on_area_entered") == 0)


func _do_remove() -> void:
    get_parent().remove_child(self)
    self.queue_free()


func _on_area_entered(_area: Area2D) -> void:
    # Area is an Enemy
    # TODO damage enemy

    # Can't do tree operations in this callback
    dead = true


func _draw() -> void:
    draw_line(position, position + Vector2(10, 0), Color.red, 3.0)


func _process(delta: float) -> void:
    if dead:
        call_deferred("_do_remove")
    var dm := Vector2(1,0).rotated(rotation) * SPEED
    position += dm * delta
