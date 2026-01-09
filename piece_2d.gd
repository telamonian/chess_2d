extends Area2D

@onready var sprite = $piece_sprite

var color: Enum.Pcolor
var type: Enum.Ptype
var grid_position: Vector2i

func setup(c: Enum.Pcolor, t: Enum.Ptype, grid_pos: Vector2i, pos: Vector2):
  color = c
  type = t
  grid_position = grid_pos
  
  sprite.setup(color, type)
  position = pos

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  pass
