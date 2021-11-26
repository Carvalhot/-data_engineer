--CARREGAR OS DADOS DE CLIENTES (1� CARGA)
WITH S AS (
     Select * From Relacional.Clientes order by id_cliente
),
UPD AS (
     UPDATE Dimensional.DimensaoCliente T
     SET    Data_Fim_Validade = current_date
     FROM   S
     WHERE  (T.ID_Cliente = S.ID_Cliente AND T.Data_Fim_Validade is null) 
    		AND (T.CLIENTE <> S.CLIENTE OR T.ESTADO <> S.ESTADO OR T.SEXO <> S.SEXO OR T.STATUS <> S.STATUS)
     RETURNING T.ID_CLIENTE
)
INSERT INTO Dimensional.DimensaoCliente(ID_Cliente, Cliente, Estado, Sexo, Status, Data_Inicio_Validade, Data_Fim_Validade)
SELECT ID_Cliente, Cliente, Estado, Sexo, Status, current_date, null FROM S
WHERE S.ID_Cliente IN (SELECT ID_Cliente FROM UPD) OR
	  S.ID_Cliente NOT IN (SELECT ID_Cliente FROM Dimensional.DimensaoCliente);

--VERIFICAMOS A CARGA
select * from dimensional.dimensaocliente ;

--CARREGAR OS DADOS DE PRODUTOS (1� CARGA)
WITH S AS (
     Select * From Relacional.Produtos
),
UPD AS (
     UPDATE Dimensional.DimensaoProduto T
     SET    Data_Fim_Validade = current_date
     FROM   S
     WHERE  (T.ID_Produto = S.ID_Produto AND T.Data_Fim_Validade is null) 
    		AND (T.Produto <> S.Produto)
     RETURNING T.ID_Produto
)
INSERT INTO Dimensional.DimensaoProduto(ID_Produto, Produto, Data_Inicio_Validade, Data_Fim_Validade)
SELECT ID_Produto, Produto, current_date, null FROM S
WHERE S.ID_Produto IN (SELECT ID_Produto FROM UPD) OR
	  S.ID_Produto NOT IN (SELECT ID_Produto FROM Dimensional.DimensaoProduto);
	  
--VERIFICAMOS A CARGA
select * from Dimensional.dimensaoProduto;

--CARREGAR OS DADOS DE VENDEDORES (1� CARGA)
WITH S AS (
     Select * From Relacional.Vendedores
),
UPD AS (
     UPDATE Dimensional.DimensaoVendedor T
     SET    Data_Fim_Validade = current_date
     FROM   S
     WHERE  (T.ID_Vendedor = S.ID_Vendedor AND T.Data_Fim_Validade is null) 
    		AND (T.Nome <> S.Nome)
     RETURNING T.ID_Vendedor
)
INSERT INTO Dimensional.DimensaoVendedor(ID_Vendedor, Nome, Data_Inicio_Validade, Data_Fim_Validade)
SELECT ID_Vendedor, Nome, current_date, null FROM S
WHERE S.ID_Vendedor IN (SELECT ID_Vendedor FROM UPD) OR
	  S.ID_Vendedor NOT IN (SELECT ID_Vendedor FROM Dimensional.DimensaoVendedor);
	 
 --VERIFICAMOS A CARGA
select * from dimensional.dimensaovendedor;


select * from dimensional.fatovendas
 
--CARREGA SOMENTE O M�S DE JANEIRO NA FATO VENDAS
INSERT INTO dimensional.fatovendas(chave_vendedor, chave_cliente, chave_produto, chave_tempo, quantidade, valor_unitario, valor_total, desconto)
Select
	Vdd.Chave_Vendedor,
    C.Chave_Cliente,
    P.Chave_Produto,
    T.Chave_Tempo,
    IV.Quantidade,
    IV.Valor_Unitario,
    IV.Valor_Total,
    IV.Desconto
From Relacional.Vendas V
Inner Join Dimensional.DimensaoVendedor Vdd
	On V.ID_Vendedor = Vdd.ID_Vendedor And Vdd.Data_Fim_Validade Is Null /*DataFimValidade Is Null representa o registro atual do Vendedor para a carga da fato no momento*/
Inner Join Relacional.ItensVenda IV
	On V.ID_Venda = IV.ID_Venda
Inner Join Dimensional.DimensaoCliente C
	On V.ID_Cliente = C.ID_Cliente And C.Data_Fim_Validade Is Null /*DataFimValidade Is Null representa o registro atual do Cliente para a carga da fato no momento*/
Inner Join Dimensional.DimensaoProduto P
	On IV.ID_Produto = P.ID_Produto And P.Data_Fim_Validade Is Null /*DataFimValidade Is Null representa o registro atual do Produto para a carga da fato no momento*/
Inner Join Dimensional.DimensaoTempo T
	On V.data_venda = T.data_completa 
Where date_part('MONTH', V.data_venda) = 01;

--VERIFICAMOS A FATO
select * from dimensional.fatovendas;

--verificamos o status dos clientes 1 at� 5 -RELACIONAL
select status from relacional.clientes WHERE ID_CLIENTE BETWEEN 1 AND 5;


--FAZ UMA ALTERA��O DE PLANO DOS CLIENTES DE ID 1 A 5 - RELACIONAL
UPDATE RELACIONAL.CLIENTES SET STATUS = 'Gold' WHERE ID_CLIENTE BETWEEN 1 AND 5;


--RECARREGAR A DIMENSAO CLIENTE. S� FAR� TRATAMENTO DE HIST�RICO NOS REGISTROS ALTERADOS (CLIENTES DE ID 1 A 5);
WITH S AS (
     Select * From Relacional.Clientes
),
UPD AS (
     UPDATE Dimensional.DimensaoCliente T
     SET    Data_Fim_Validade = current_date
     FROM   S
     WHERE  (T.ID_Cliente = S.ID_Cliente AND T.Data_Fim_Validade is null) 
    		AND (T.CLIENTE <> S.CLIENTE OR T.ESTADO <> S.ESTADO OR T.SEXO <> S.SEXO OR T.STATUS <> S.STATUS)
     RETURNING T.ID_CLIENTE
)
INSERT INTO Dimensional.DimensaoCliente(ID_Cliente, Cliente, Estado, Sexo, Status, Data_Inicio_Validade, Data_Fim_Validade)
SELECT ID_Cliente, Cliente, Estado, Sexo, Status, current_date, null FROM S
WHERE S.ID_Cliente IN (SELECT ID_Cliente FROM UPD) OR
	  S.ID_Cliente NOT IN (SELECT ID_Cliente FROM Dimensional.DimensaoCliente);

--CONSULTA OS CLIENTES ALTERADOS PARA VERIFICAR O HIST�RICO DE CADA CLIENTE. CAMPOS DE DATA FORAM ATUALIZADOS
SELECT * FROM DIMENSIONAL.DIMENSAOCLIENTE WHERE ID_CLIENTE BETWEEN 1 AND 5;

--VERIFICA QUE OS CLIENTES DA CARGA DA FATO REFERENTE � JANEIRO EST�O APONTANDO PARA AS SKs ANTIGAS DOS CLIENTES DE 1,2,3 e 5
--POIS A CARGA DA FATO FOI FEITA ANTES 
SELECT f.chave_cliente,c.cliente FROM dimensional.fatovendas f
	inner join dimensional.dimensaocliente c
    	on f.chave_cliente = c.chave_cliente
where c.id_cliente between 1 and 5;
	 

--CARREGA SOMENTE O M�S DE FEVEREIRO NA FATO VENDAS
INSERT INTO dimensional.fatovendas(chave_vendedor, chave_cliente, chave_produto, chave_tempo, quantidade, valor_unitario, valor_total, desconto)
Select
	Vdd.Chave_Vendedor,
    C.Chave_Cliente,
    P.Chave_Produto,
    T.Chave_Tempo,
    IV.Quantidade,
    IV.Valor_Unitario,
    IV.Valor_Total,
    IV.Desconto
From Relacional.Vendas V
Inner Join Dimensional.DimensaoVendedor Vdd
	On V.ID_Vendedor = Vdd.ID_Vendedor And Vdd.Data_Fim_Validade Is Null /*DataFimValidade Is Null representa o registro atual do Vendedor para a carga da fato no momento*/
Inner Join Relacional.ItensVenda IV
	On V.ID_Venda = IV.ID_Venda
Inner Join Dimensional.DimensaoCliente C
	On V.ID_Cliente = C.ID_Cliente And C.Data_Fim_Validade Is Null /*DataFimValidade Is Null representa o registro atual do Cliente para a carga da fato no momento*/
Inner Join Dimensional.DimensaoProduto P
	On IV.ID_Produto = P.ID_Produto And P.Data_Fim_Validade Is Null /*DataFimValidade Is Null representa o registro atual do Produto para a carga da fato no momento*/
Inner Join Dimensional.DimensaoTempo T
	On V.data_venda = T.data_completa 
Where date_part('MONTH', V.data_venda) = 02;


--VERIFICA QUE OS CLIENTES DA CARGA DA FATO REFERENTE � JANEIRO EST�O APONTANDO PARA AS SKs ANTIGAS DOS CLIENTES DE 1 A 5. EM FEVEREIRO SOMENTE O CLIENTE 5 REALIZOU COMPRAS.
--OS REGISTROS DA FATO J� APONTAM PARA A �LTIMA SK DO CLIENTE
SELECT f.valor_total, t.data_completa ,f.chave_cliente,c.id_cliente,c.cliente FROM dimensional.fatovendas f
	inner join dimensional.dimensaocliente c
    	on f.chave_cliente = c.chave_cliente
	inner join dimensional.dimensaotempo t
    	on f.chave_tempo = t.chave_tempo
where c.id_cliente between 1 and 5;


 --CARREGA SOMENTE O M�S DE MAR�O NA FATO VENDAS
INSERT INTO dimensional.fatovendas(chave_vendedor, chave_cliente, chave_produto, chave_tempo, quantidade, valor_unitario, valor_total, desconto)
Select
	Vdd.Chave_Vendedor,
    C.Chave_Cliente,
    P.Chave_Produto,
    T.Chave_Tempo,
    IV.Quantidade,
    IV.Valor_Unitario,
    IV.Valor_Total,
    IV.Desconto
From Relacional.Vendas V
Inner Join Dimensional.DimensaoVendedor Vdd
	On V.ID_Vendedor = Vdd.ID_Vendedor And Vdd.Data_Fim_Validade Is Null /*DataFimValidade Is Null representa o registro atual do Vendedor para a carga da fato no momento*/
Inner Join Relacional.ItensVenda IV
	On V.ID_Venda = IV.ID_Venda
Inner Join Dimensional.DimensaoCliente C
	On V.ID_Cliente = C.ID_Cliente And C.Data_Fim_Validade Is Null /*DataFimValidade Is Null representa o registro atual do Cliente para a carga da fato no momento*/
Inner Join Dimensional.DimensaoProduto P
	On IV.ID_Produto = P.ID_Produto And P.Data_Fim_Validade Is Null /*DataFimValidade Is Null representa o registro atual do Produto para a carga da fato no momento*/
Inner Join Dimensional.DimensaoTempo T
	On V.data_venda = T.data_completa 
Where date_part('MONTH', V.data_venda) = 03;

--EM MAR�O NENHUM DOS CLIENTES QUE ESTAMOS MAPEANDO (1 A 5) FEZ COMPRAS.
SELECT * FROM dimensional.fatovendas f
	inner join dimensional.dimensaocliente c
    	on f.chave_cliente = c.chave_cliente
    inner join dimensional.dimensaotempo t
    	on f.chave_tempo = t.chave_tempo
where c.id_cliente between 1 and 5 and t.mes = 3;


--FAZ UMA ALTERA��O NO PLANO DO CLIENTE 3
UPDATE RELACIONAL.CLIENTES SET STATUS = 'Platinum' WHERE ID_CLIENTE = 3;

--CARREGAR OS DADOS DE CLIENTES. S� FAR� TRATAMENTO DE HIST�RICO NOS REGISTROS ALTERADOS (CLIENTE 3)
WITH S AS (
     Select * From Relacional.Clientes
),
UPD AS (
     UPDATE Dimensional.DimensaoCliente T
     SET    Data_Fim_Validade = current_date
     FROM   S
     WHERE  (T.ID_Cliente = S.ID_Cliente AND T.Data_Fim_Validade is null) 
    		AND (T.CLIENTE <> S.CLIENTE OR T.ESTADO <> S.ESTADO OR T.SEXO <> S.SEXO OR T.STATUS <> S.STATUS)
     RETURNING T.ID_CLIENTE
)
INSERT INTO Dimensional.DimensaoCliente(ID_Cliente, Cliente, Estado, Sexo, Status, Data_Inicio_Validade, Data_Fim_Validade)
SELECT ID_Cliente, Cliente, Estado, Sexo, Status, current_date, null FROM S
WHERE S.ID_Cliente IN (SELECT ID_Cliente FROM UPD) OR
	  S.ID_Cliente NOT IN (SELECT ID_Cliente FROM Dimensional.DimensaoCliente);
	  
 --CONSULTA OS CLIENTES ALTERADOS PARA VERIFICAR O HIST�RICO DE CADA CLIENTE. CAMPOS DE DATA FORAM ATUALIZADOS
SELECT * FROM DIMENSIONAL.DIMENSAOCLIENTE WHERE ID_CLIENTE BETWEEN 1 AND 5;



 --CARREGA SOMENTE OS OUTROS MESES
INSERT INTO dimensional.fatovendas(chave_vendedor, chave_cliente, chave_produto, chave_tempo, quantidade, valor_unitario, valor_total, desconto)
Select
	Vdd.Chave_Vendedor,
    C.Chave_Cliente,
    P.Chave_Produto,
    T.Chave_Tempo,
    IV.Quantidade,
    IV.Valor_Unitario,
    IV.Valor_Total,
    IV.Desconto
From Relacional.Vendas V
Inner Join Dimensional.DimensaoVendedor Vdd
	On V.ID_Vendedor = Vdd.ID_Vendedor And Vdd.Data_Fim_Validade Is Null /*DataFimValidade Is Null representa o registro atual do Vendedor para a carga da fato no momento*/
Inner Join Relacional.ItensVenda IV
	On V.ID_Venda = IV.ID_Venda
Inner Join Dimensional.DimensaoCliente C
	On V.ID_Cliente = C.ID_Cliente And C.Data_Fim_Validade Is Null /*DataFimValidade Is Null representa o registro atual do Cliente para a carga da fato no momento*/
Inner Join Dimensional.DimensaoProduto P
	On IV.ID_Produto = P.ID_Produto And P.Data_Fim_Validade Is Null /*DataFimValidade Is Null representa o registro atual do Produto para a carga da fato no momento*/
Inner Join Dimensional.DimensaoTempo T
	On V.data_venda = T.data_completa 
Where date_part('MONTH', V.data_venda) > 03;

--VERIFICA TODAS AS COMPRAS DOS CLIENTES QUE ESTAMOS MAPEANDO (1 A 5). VERIFICAMOS QUE HAVIA COMPRAS COM A SK ANTIGA E AGORA H� COMPRAS FEITAS COM O �LTIMO STATUS (SK NOVA)
SELECT f.valor_total , t.data_completa ,f.chave_cliente,c.id_cliente,c.cliente FROM dimensional.fatovendas f
	inner join dimensional.dimensaocliente c
    	on f.chave_cliente = c.chave_cliente
	inner join dimensional.dimensaotempo t
    	on f.chave_tempo = t.chave_tempo
where c.id_cliente between 1 and 5;