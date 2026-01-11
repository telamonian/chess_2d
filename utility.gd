extends Node

func get_local_scene_root(p_node : Node) -> Node:
  # see: https://forum.godotengine.org/t/get-root-node-from-any-node/20750/4
  while(p_node and not p_node.filename):
     p_node = p_node.get_parent()

  return p_node as Node
