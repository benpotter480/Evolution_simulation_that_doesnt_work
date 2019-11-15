extends Control

var started
var playing

func _ready():
	
	# disabling most buttons
	$simulation_parts/stop_button.disabled = true
	$simulation_parts/pause_button.disabled = true
	$simulation_parts/ff_button.disabled = true

func _physics_process(delta):
	print(1/delta)

func _on_play_button_pressed():
	if !started:
		started = true
	playing = true
	# making buttons pressable
	$simulation_parts/stop_button.disabled = false
	$simulation_parts/pause_button.disabled = false
	$simulation_parts/ff_button.disabled = false


func _on_pause_button_pressed():
	playing = false
	$simulation_parts/pause_button.disabled = true
	$simulation_parts/play_button.disabled = false


func _on_stop_button_pressed():
	$simulation_parts/play_button.disabled = true
	$simulation_parts/stop_button.disabled = true
	$simulation_parts/pause_button.disabled = true
	$simulation_parts/ff_button.disabled = true
