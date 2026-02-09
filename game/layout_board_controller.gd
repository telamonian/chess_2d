extends Control

@onready var tmlayer = $Game_2d/Board_2d/TileMapLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  item_rect_changed.connect(_update_tmlayer)

func _update_tmlayer():
  tmlayer.global_position = global_position

  var base_width = 8.0*128.0
  var new_scale = size.x / base_width
  tmlayer.scale = Vector2(new_scale, new_scale)
