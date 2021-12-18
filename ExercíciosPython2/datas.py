#
# Arquivo com exemplos de manipulação de  datas
#

from datetime import date
from datetime import time
from datetime import datetime

def manipulaDataHora():
    hoje = date.today()
    print("hoje é {}".format(hoje))
    print("Partes da data: {} {} {}".format(hoje.day, hoje.month, hoje.year))
    print("Número do dia da semana: {}".format(hoje.weekday()))
    dias = ["seg", "ter", "qua", "qui", "sex", "sab", "dom"]
    print("Nome abreviado do dia da semana: {}".format(dias[hoje.weekday()]))

    data = datetime.now()
    print("Data e hora: {}".format(data))

    tempo = datetime.time(data)
    print("Hora atual: {}".format(tempo))
manipulaDataHora()