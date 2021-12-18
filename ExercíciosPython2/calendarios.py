#
# Arquivo com exemplos de uso de calendários
#

import calendar

# criando um calendário no formato texto
def calendarioTexto():
    calendarioTexto = calendar.TextCalendar(calendar.SUNDAY)
    txtCalendario = calendarioTexto.formatmonth(2022,1)
    print(txtCalendario)

calendarioTexto()


# Criando um calendário no formato HTML

def calendarioHTML():
    calendarioHTML = calendar.HTMLCalendar(calendar.SUNDAY)
    htmlCalendario = calendarioHTML.formatmonth(2022, 1)
    print(htmlCalendario)

calendarioHTML()


# loop ao longo dos dias de um mês




