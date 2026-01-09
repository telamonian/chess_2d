extends Sprite2D

func setup(color: Enum.Pcolor, type: Enum.Ptype):
  set_color(color)
  set_type(type)

func set_color(color: Enum.Pcolor):
  frame_coords.y = color

func set_type(type: Enum.Ptype):
  frame_coords.x = type
  
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  pass
