extends Area2D


const SPEED: float = 1000.0


var dead: bool = false
var damage: float = 30.0 # Damage dealt
var ttl: float = 5.0 # Seconds


func _ready() -> void:
    assert(connect("area_entered", self, "_on_area_entered") == 0)


func _do_remove() -> void:
    get_parent().remove_child(self)
    self.queue_free()


func _on_area_entered(area: Area2D) -> void:
    var enemy: Enemy = area
    enemy.hurt(damage)

    # Can't do tree operations in this callback
    dead = true


func _process(delta: float) -> void:
    ttl -= delta
    if ttl <= 0.0:
        dead = true

    if dead:
        call_deferred("_do_remove")
    var dm := Vector2(1,0).rotated(rotation) * SPEED
    position += dm * delta
