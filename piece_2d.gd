extends Area2D
@onready var sprite = $piece_sprite

func setup(color: Enum.Pcolor, type: Enum.Ptype, pos: Vector2):
  sprite.setup(color, type)
  position = pos

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  pass
