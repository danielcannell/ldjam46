extends Area2D


const SPEED: float = 1000.0


var dead: bool = false
var damage: float = 30.0 # Damage dealt
var ttl: float = 5.0 # Seconds
var damage_type: int = Globals.DamageType.NORMAL
var fire_time := 3.0 # Time an enemy will burn for
var slow_amount := 0.5 # Speed multiplier
var slow_time := 3.0 # Slowness time


func _ready() -> void:
    var err := connect("area_entered", self, "_on_area_entered"); assert(err == 0)


func _do_remove() -> void:
    get_parent().remove_child(self)
    self.queue_free()


func _on_area_entered(area: Area2D) -> void:
    var enemy: Enemy = area
    if damage_type == Globals.DamageType.NORMAL:
        enemy.hurt(damage)
    elif damage_type == Globals.DamageType.FIRE:
        enemy.set_on_fire(fire_time)
    elif damage_type == Globals.DamageType.SLOWNESS:
        enemy.apply_slowness(slow_amount, slow_time)
    else:
        assert(false)

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
