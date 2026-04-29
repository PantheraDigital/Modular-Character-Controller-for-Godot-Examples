extends Area3D

## Area trigger that gives characters in the ControllableCharacter group Dash. \
## Character name changes dash type.


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group(&"ControllableCharacter"):
		var action_player: ActionPlayer = body.find_child("ActionPlayer", false)
		if !action_player or action_player._action_container.has(^"Dash"):
			return
		
		var node: Node = Node.new()
		node.name = &"Dash"
		
		var anim_tree: AnimationTree = body.find_child("AnimationTree")
		
		if anim_tree:
			node.set_script(load("res://scripts/actions/animated_character/action_dash_with_anim.gd"))
			node._anim_tree = anim_tree
			node._collider_anim_player = body.find_child("CollisionShape3D").find_child("AnimationPlayer")
		else:
			node.set_script(load("res://scripts/actions/simple_character/action_dash.gd"))
			node._collision_shape_3d = body.find_child("CollisionShape3D")
		
		node._movement_class = body.find_child("GroundedMovement")
		
		action_player.add_child(node)
		action_player.set_request(self, &"dash", node.get_path()) # add to active map
		
		get_parent().queue_free()
