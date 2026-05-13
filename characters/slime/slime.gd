extends Node2D


func play_walk():
	%AnimationPlayer.play("walk")


func play_hurt():
	
	%AnimationPlayer.queue("walk")
