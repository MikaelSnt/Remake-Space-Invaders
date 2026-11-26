extends CanvasLayer


@onready var valor_pontos: Label = $texto_Pontos/valor_pontos
@onready var valor_vidas: Label = $texto_Vidas/valor_vidas


func _process(_delta: float) -> void:
	valor_pontos.text = "%04d" % GameManager.pontuacao # O nome vai ser o que ta escrito ai, la é so para ter uma noçao 
	valor_vidas.text = "%d" % GameManager.vidas
	
	if GameManager.jogo_acabou:
		# nao temos o ainda, mas vai ficar aqui vai ser tipo trocar de cena,mas pode ser instanciar tbm  
		pass
