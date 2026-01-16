extends Sprite2D

const highlight_material = preload("res://game/piece/highlight.material")

var highlight_material_color_opt: Opt.Option = Opt.set_option("game", "piece_highlight", Color(1.0, 0.071, 0.263, 1.0)) #highlight_material.get_shader_parameter("Color")) # Color(0, 0, 0, 0))

func _set_highlight_material_color(opt: Opt.Option):
  highlight_material.set_shader_parameter("color", opt.value)

func setup(color: Enum.Pcolor, type: Enum.Ptype):
  _set_highlight_material_color(highlight_material_color_opt)
  highlight_material_color_opt.changed.connect(_set_highlight_material_color)

  set_color(color)
  set_type(type)

func set_color(color: Enum.Pcolor):
  frame_coords.y = color

func set_type(type: Enum.Ptype):
  frame_coords.x = type

func set_highlight():
  material = highlight_material

func unset_highlight():
  material = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  pass
