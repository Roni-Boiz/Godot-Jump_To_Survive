extends Area2D

onready var animation_player: AnimationPlayer = get_node("AnimationPlayer")

export var score := 10

func _on_Coin_body_entered(body: Node) -> void:
	animation_player.play("fade_out")
	PlayerData.score += score
