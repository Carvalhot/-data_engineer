#
# Exemplo de como criar classes
#
class minhaClasse():
    def __init__(self):
        self.meuAtributo = "Passou pelo construtor!"

    def meuMetodo(self):
        print("Passou pelo meu método")

    def meuMetodo2(self, valor):
        self.outroAtributo = valor
        print(self.outroAtributo)

def criaObjeto():
    meuObj = minhaClasse()
    var1 = meuObj.meuAtributo
    print(var1)

    meuObj.meuMetodo()
    meuObj.meuMetodo2("Executando um metodo")

criaObjeto()


