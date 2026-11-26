extends Control

@onready var valor_pontu: Label = $VBoxContainer/pontuacao/valor_pontu
@onready var reset_bnt: Button = $VBoxContainer/reset_bnt


func _ready() -> void:
	get_tree().paused = false
	valor_pontu.text = " %04d" % GameManager.pontuacao
	reset_bnt.pressed.connect(_on_botao_reiniciar_pressed)
	reset_bnt.grab_focus() # deixa usar o  Enter ou Espaço

func _on_botao_reiniciar_pressed() -> void:
	GameManager.resetar_jogo()
