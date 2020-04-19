extends Node2D

class_name Explosion

const ExplosionTexture = preload("res://Art/fire.png")


const MAX_SIZE = 2
const TTL = 0.1
var age := 0.0
var explosion: Sprite


func _init():
    explosion = Sprite.new()
    explosion.texture = ExplosionTexture
    explosion.scale = Vector2(0, 0)
    add_child(explosion)


func _do_remove() -> void:
    get_parent().remove_child(self)
    self.queue_free()


func _process(delta: float) -> void:
    age += delta
    
    var scale := MAX_SIZE * age / TTL
    explosion.scale = Vector2(scale, scale)
    
    if age > TTL:
        call_deferred("_do_remove")
