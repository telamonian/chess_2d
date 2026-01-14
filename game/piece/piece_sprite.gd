extends Sprite2D

func setup(color: Enum.Pcolor, type: Enum.Ptype):
  set_color(color)
  set_type(type)

func set_color(color: Enum.Pcolor):
  frame_coords.y = color

func set_type(type: Enum.Ptype):
  frame_coords.x = type

func set_highlight(hcolor: Color = Color(1.0, 0.071, 0.263, 1.0)):
  var highlight_material = load("res://game/piece/highlight.material")
  highlight_material.set_shader_parameter("Color", hcolor)

  material = highlight_material

func unset_highlight():
  material = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  pass
