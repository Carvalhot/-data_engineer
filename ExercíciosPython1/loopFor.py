#
# Arquivo com exemplos de Loops
#

# Definindo um LOOP FOR
def loopFor():
    for x in range(5,10):
        print(x)

loopFor()
print('-'*30)

# Usando um LOOP FOR em uma coleção
def loopArray():
    dias = ['seg', "ter", "qua", "qui", "sex", "sab", "dom"]
    for d in dias:
        print(d)

loopArray()
print('-'*30)

# Usando a função enumerate, paara buscar valoeres e seus índices
def loopEnum():
    dias = ['seg', "ter", "qua", "qui", "sex", "sab", "dom"]
    for i, d in enumerate(dias):
        print(i+1,d)

loopEnum()
