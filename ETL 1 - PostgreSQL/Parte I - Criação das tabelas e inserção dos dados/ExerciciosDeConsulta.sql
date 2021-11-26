--COMPRAS DE UM CLIENTE ESPECÍFICO
select c.cliente, p.produto, i.quantidade, i.valor_total, v.data_venda 
from relacional.clientes as c 
inner join relacional.vendas as v on (c.id_cliente = v.id_cliente) 
inner join relacional.itensvenda i on (i.id_venda = v.id_venda) 
inner join relacional.produtos p on (p.id_produto = i.id_produto) 
where c.id_cliente = 1;

--LISTA DOS 5 PIORES VENDEDORES
select vdd.nome, count(vdd.nome) as totVendas 
from relacional.vendas as v 
inner join relacional.vendedores as vdd on(v.id_vendedor = vdd.id_vendedor) 
group by vdd.nome 
order by totVendas limit 5;

--LISTA DOS 5 MELHORES VENDEDORES
select vdd.nome, count(vdd.nome) as totVendas 
from relacional.vendas as v 
inner join relacional.vendedores as vdd on(v.id_vendedor = vdd.id_vendedor) 
group by vdd.nome 
order by totVendas desc limit 5;

--TOTAL DE VENDAS EM PERÍODO
select p.produto, sum(i.quantidade) as totVendas 
from relacional.produtos as p 
inner join relacional.itensvenda as i on(p.id_produto = i.id_produto) 
inner join relacional.vendas as v on(i.id_venda = v.id_venda) 
where v.data_venda between '2016-01-01' and '2016-01-15' 
group by p.produto

--TOTAL DE DESCONTOS POR PRODUTO
select p.produto,sum(i.desconto) as totDesconto 
from relacional.produtos as p 
inner join relacional.itensvenda as i on(p.id_produto = i.id_produto) 
inner join relacional.vendas as v on(i.id_venda = v.id_venda) 
inner join relacional.vendedores as vdd on(v.id_vendedor = vdd.id_vendedor) 
group by p.produto 
order by totDesconto desc

--TOTAL DE DESCONTOS POR VENDEDOR
select vdd.nome, sum(i.desconto) as totDesconto 
from relacional.produtos as p 
inner join relacional.itensvenda as i on(p.id_produto = i.id_produto) 
inner join relacional.vendas as v on(i.id_venda = v.id_venda) 
inner join relacional.vendedores as vdd on(v.id_vendedor = vdd.id_vendedor) 
group by vdd.nome 
order by totDesconto desc