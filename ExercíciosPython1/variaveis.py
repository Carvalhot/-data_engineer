
# Declarando e inicializando uma variável
f = 0 
print(f)

# declarando a mesma variável novamente
f = "abc"
print(f)

# Gerando um erro, tentando unir variáveis de tipos diferentes

# print('isto é uma string' + 123)
print('isto é uma string ' + str(123))

# Variável Global X Variável local
print('-'*30)
def Funcao():
    f = "def"
    print(f)

Funcao()
print(f)

# Variável global dentro da função
print('-'*30)

def Funcao2():
    global g
    g = "def"
    print(g)

Funcao2()
print(g)

