extends Node2D

#preload("res://game/board/highlight.gd")

var highlight: BoardHighlight

func add_highlight():
  highlight = BoardHighlight.new(get_parent().tmlayer, Color(1.0, 1.0, 0.259, 1.0))
  add_child(highlight)

func remove_highlight():
  remove_child(highlight)
  highlight.queue_free()
  highlight = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  pass
