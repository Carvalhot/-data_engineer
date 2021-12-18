#
# Arquivo de exemplo para uso da classe timedeltas
#

from datetime import date
from datetime import time
from datetime import datetime
from datetime import timedelta

def quantosDiasFaltam(ano,mes, dia):
    hoje = date.today()
    dataProcurada = date(ano, mes, dia)

    qtdDias = dataProcurada - hoje

    print("Faltam {}dias para a data {}".format(qtdDias, dataProcurada.strftime("%d/%m/%Y")).replace('days, 0:00:00',''))

quantosDiasFaltam(2021,12,15)