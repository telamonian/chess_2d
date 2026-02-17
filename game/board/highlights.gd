extends Node2D

var highlight: BoardHighlight = null

func set_highlight(squares: Array[Vector2i]):
  if highlight != null:
    remove_highlight()
  highlight = BoardHighlight.new(squares, get_parent().tmlayer)
  add_child(highlight)

func remove_highlight():
  highlight = get_child(0)
  remove_child(highlight)
  highlight.queue_free()
  highlight = null
