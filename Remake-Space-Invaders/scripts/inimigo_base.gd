extends Area2D
class_name Inimigo_base #Criando uma class base 

@export_group("Atributos")
@export var vida := 1
@export var pontos := 1

@export_group("Movimentação") #para ficar bonitinho quando a gente for mexer 
@export var velocidade := 80.0
@export var tempo_para_virar:= 2.0 # Segundos andando para um lado antes de voltar
@export var descida:= 20. # Quanto desce quando ele voltar  
@export var direcao:= 1 # 1 = direita, -1 = esquerda

var cronometro:= 0.0 # em float pq da para contar melhor 
func _ready() -> void:
	area_entered.connect(_on_area_entered)
func _physics_process(delta: float) -> void:
	position.x += direcao * velocidade * delta # Movimenta de lado 
	cronometro += delta # Conta o tempo 
	if cronometro >= tempo_para_virar: # Quando for igual ao tempo de virar vai zerar o cronômetro, inverter o lado e descer
		cronometro = 0.0
		direcao *= -1
		position.y += descida

func receber_dano(dano: int) -> void:
	vida -= dano
	if vida <= 0:
		GameManager.adicionar_pontos(pontos)
		queue_free()
		
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("limite_invasao"):
		GameManager.game_over()
