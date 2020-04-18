extends Camera2D


func _ready():
    self.offset = Vector2(0, 0)
    self.zoom = Vector2(0.1, 0.1)
    

const SPEED = 4

func _unhandled_input(event):
    if event is InputEventKey:
        if event.pressed:
            if (event.scancode == KEY_A):
                self.position += Vector2(-SPEED, 0)
            if (event.scancode == KEY_D):
                self.position += Vector2(SPEED, 0)
            if (event.scancode == KEY_W):
                self.position += Vector2(0, -SPEED)
            if (event.scancode == KEY_S):
                self.position += Vector2(0, SPEED)

            print(event) 
