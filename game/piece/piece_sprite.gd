extends Sprite2D

const highlight_material = preload("res://game/piece/highlight.material")

func _set_highlight_material_color(opt: Opt.Option):
  highlight_material.set_shader_parameter("color", opt.value)

func setup(color: Enum.Pcolor, type: Enum.Ptype):
  var highlight_material_color_opt: Opt.Option = Opt.get_option_by_section("game", "piece_highlight")
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
