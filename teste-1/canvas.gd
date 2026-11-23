extends CanvasLayer

func _ready(): #Código para atualizar o texto dos pontos e vidas da label
	var pontos = 0
	var vidas = 3
	var label = get_node("Label")
	label.text = str(pontos) + " pontos\n" + str(vidas) + " vidas"
	
