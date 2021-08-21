extends Node2D

onready var state_machine: AnimationNodeStateMachinePlayback = $AnimationTree.get("parameters/playback")


func start_magic() -> void:
	state_machine.travel('magic_loop')


func stop_magic() -> void:
	state_machine.travel('idle')
